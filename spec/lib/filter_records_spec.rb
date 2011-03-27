require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "OaiHarvester::SolrHelper::FilterRecords" do
  before(:all) do
    module MockSolrHelper
      def solr_search_params(extra_controller_params)
        {}
      end
    end

    @mock_class = Class.new do
      include MockSolrHelper
      include OaiHarvester::SolrHelper::FilterRecords
    end
  end

  it "should add filter to remove deleted records" do
    @mock_class.new.solr_search_params({}).should == {:filters => {:"-deleted_b" => 1 } }
  end
end
