class Provider < ActiveRecord::Base
  def consume!
    provider_config = oai_client.identify

    response = nil
    count = 0
    options = { :set => self.set, :metadata_prefix => self.metadata_prefix, :from => self.last_consumed_at.clone.utc.xmlschema }

    self.last_consumed_at = Time.now
    begin
      options[:resumption_token] = response.resumption_token if response and response.resumption_token and not response.resumption_token.empty? 
      response = oai_client.list_records(options)
      response.doc.find("/OAI-PMH/ListRecords/record").to_a.each_slice(50) do |records|
        Blacklight.solr.add records.map { |rec| convert_record_to_solrdoc(rec) }
        count += records.length
      end
    end while response.resumption_token and not response.resumption_token.empty?

    Blacklight.solr.commit

    self.save

    count
  end


  private
  def oai_client
    @oai_client ||= OAI::Client.new(self.endpoint, :parser => 'libxml')
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
    solrdoc['format'] = solrdoc['format'].first.parameterize('_') if solrdoc['format']

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
    @xslt ||=  Nokogiri::XSLT(open(self.stylesheet))
  end
end
