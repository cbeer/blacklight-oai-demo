class Provider < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  before_save :load_set_metadata

  def consume!
    provider_config = oai_client.identify

    response = nil
    count = 0

    return 0 unless self.stylesheet

    from = self.last_consumed_at
    from ||= Time.at(0)

    options = { :set => self.set, :metadata_prefix => self.metadata_prefix, :from => from.clone.utc.xmlschema }

    self.last_consumed_at = Time.now
    begin
      begin
        options[:resumption_token] = response.resumption_token if response and response.resumption_token and not response.resumption_token.empty? 
        response = oai_client.list_records(options)
        response.doc.find("/OAI-PMH/ListRecords/record").to_a.each_slice(50) do |records|
          Blacklight.solr.add records.map { |rec| convert_record_to_solrdoc(rec) }
          count += records.length
        end
      end while response.resumption_token and not response.resumption_token.empty?
    rescue 
      raise $! unless $!.respond_to?(:code)
      raise $! unless $!.code ==  "noRecordsMatch"
      return 0
    end

    Blacklight.solr.commit

    self.save

    count
  end

  def identify
    oai_client.identify rescue nil
  end
  memoize :identify

  def sets
    oai_client.list_sets.to_a rescue []
  end
  memoize :sets

  def set_metadata spec = nil
    return nil unless spec
    self.sets.select { |x| x.spec == spec }.first rescue nil
  end
  memoize :set_metadata

  def metadata_formats
    oai_client.list_metadata_formats.to_a rescue []
  end
  memoize :metadata_formats

  private
  def oai_client
    OAI::Client.new(self.endpoint, :parser => 'libxml') rescue nil
  end
  memoize :oai_client

  def load_set_metadata
    return if self.endpoint.blank? or self.set.blank?

    metadata = self.set_metadata(self.set)

    doc = Nokogiri::XML(metadata.description.to_s)

    if self.title.blank?
      title = doc.xpath('//dc:title/text()', 'dc' => "http://purl.org/dc/elements/1.1/").first.to_s rescue nil
      title ||= metadata.name if metadata.name
      self.title = title
    end

    if self.description.blank?
      description = doc.xpath('//dc:description/text()', 'dc' => "http://purl.org/dc/elements/1.1/").first.to_s rescue nil
      self.description = description 
    end
  end

  def convert_record_to_solrdoc(record)
    doc = Nokogiri::XML(record.to_s)
    solrdoc = xslt.transform(doc)

    solrdoc = solrdoc.xpath('//field').to_a.inject({}) do |memo, obj| 
      memo[obj['name']] ||= []
      memo[obj['name']] << obj.text
      memo
    end

    solrdoc['id'] = (solrdoc['identifier_s'] || solrdoc['id']).first.parameterize
    solrdoc['format'] &&= solrdoc['format'].first.parameterize('_') 

    solrdoc['deleted_b'] &&= solrdoc['deleted_b'].first
    solrdoc['deleted_b'] ||= false

    solrdoc['dc_subject_hier_facet'] = solrdoc['dc_subject_t'].map { |str| val = []; tokens = str.split('--'); i = 0; val << tokens.take(i+=1) until i == tokens.length; val.map { |x| x.join('--') }  }.flatten.compact.uniq if solrdoc['dc_subject_t']
    solrdoc['dc_date_year_i'] = solrdoc['dc_date_t'].map { |x| x.scan(/\d{4}/).first }.flatten.compact.uniq if solrdoc['dc_date_t']

    solrdoc['provider_id_i'] = self.id
    solrdoc['provider_harvested_dt'] = self.last_consumed_at.utc.xmlschema
    solrdoc['provider_s'] = self.title
    solrdoc['provider_endpoint_s'] = self.endpoint

    solrdoc['harvested_record_t'] = record.to_s

    solrdoc
  end

  def xslt
    Nokogiri::XSLT(open(self.stylesheet))
  end
  memoize :xslt

end
