class Provider < ActiveRecord::Base
  def consume!
    client = OAI::Client.new(endpoint, :parser => 'libxml')
    provider_config = client.identify

    response = nil
    count = 0
    options = { :set => set, :metadata_prefix => metadata_prefix, :from => last_consumed_at.clone.utc.xmlschema }

    last_consumed_at = Time.now
    begin
      options[:resumption_token] = response.resumption_token if response and response.resumption_token and not response.resumption_token.empty? 
      response = client.list_records(options)
      response.doc.find("/OAI-PMH/ListRecords/record").to_a.each_slice(50) do |records|
        Blacklight.solr.add records.map { |rec| convert_record_to_solrdoc(rec) }
        count += records.length
      end
    end while response.resumption_token and not response.resumption_token.empty?

    Blacklight.solr.commit

    save
  end

  private
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

    solrdoc['provider_id_i'] = id
    solrdoc['provider_harvested_dt'] = last_consumed_at.utc.xmlschema
    solrdoc['provider_s'] = title
    solrdoc['provider_endpoint_s'] = endpoint

    solrdoc['harvested_record_t'] = record.to_s

    solrdoc
  end

  def xslt
    @xslt ||=  Nokogiri::XSLT(open(stylesheet))
  end
end
