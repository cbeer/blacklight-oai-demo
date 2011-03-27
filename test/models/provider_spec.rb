require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ProviderSpecHelper

end

describe Provider do
  include ProviderSpecHelper

  before(:each) do 
    @provider = Provider.new
  end

  it "should, given an endpoint and set name, automatically fill in metadata fields" do
    @provider.attributes = { :endpoint => 'http://international.loc.gov/cgi-bin/oai2_0', :set => 'wright' }
    @provider.save
    @provider.title.should == "Records for collection of glass negatives from the Papers of Wilbur and Orville Wright, digitized by the Library of Congress"
    @provider.description.should =~ /^Orville and Wilbur Wright/
  end

  it "should not automatically fill in metadata fields if metadata is provided" do
    @provider.attributes = { :title => 'ABCD', :description => '1234', :endpoint => 'http://international.loc.gov/cgi-bin/oai2_0', :set => 'wright' }
    @provider.save
    @provider.title.should == 'ABCD'
    @provider.description.should == '1234'
  end

  it "should convert OAI-PMH record to Solr document hash" do
    @provider.attributes = { :stylesheet => 'public/xslt/oai_dc.xsl' }
    @provider.save

    record = '<record><header><identifier>test:identifier</identifier><datestamp>1970-01-01T00:00:00Z</datestamp></h
    eader><metadata></metadata></record>'

    hash = @provider.send :convert_record_to_solrdoc, record
    hash['id'].should == "test:identifier".parameterize
    hash['format'].should == 'oai_pmh_oai_dc'
    hash['deleted_b'].should == false
    hash['provider_id_i'].should == @provider.id
    hash['harvested_record_t'].should == record
  end
end
