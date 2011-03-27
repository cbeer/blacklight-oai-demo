module OaiHarvester::SolrHelper::FilterRecords
  def self.included(some_class)

  end

  def solr_search_params(extra_controller_params)
    solr_params = super(extra_controller_params)
    solr_params.merge(filter_params)
  end

  def filter_params
    return {:filters => {:"-deleted_b" => 1 } }
  end



end
