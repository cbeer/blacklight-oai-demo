class Provider < ActiveRecord::Base
  def consume!
    client = OAI::Client.new(endpoint, :parser => 'libxml')
    provider_config = client.identify

    response = nil
    count = 0
    options = { :set => set, :metadata_prefix => metadata_prefix, :from => updated_at }

    begin
      options[:resumption_token] = response.resumption_token if response and response.resumption_token and not response.resumption_token.empty? 
      response = client.list_records(options)
      response.doc.find("/OAI-PMH/ListRecords/record").to_a.each_slice(50) do |records|
        Blacklight.solr.update :data => "<add>#{records.map { |rec| convert_record_to_solrdoc(rec) } }</add>"
        count += records.length
      end
    end while response.resumption_token and not response.resumption_token.empty?

    Blacklight.solr.commit
  end

  private
  def convert_record_to_solrdoc(record)
    doc = Nokogiri::XML(record.to_s)
    xslt.transform(doc).to_s.gsub("<?xml version=\"1.0\"?>\n", '')
  end

  def xslt
    @xslt ||=  Nokogiri::XSLT(open(stylesheet))
  end
end
