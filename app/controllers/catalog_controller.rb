require_dependency('vendor/plugins/blacklight/app/controllers/catalog_controller.rb')

class CatalogController < ApplicationController
  include OaiHarvester::SolrHelper::FilterRecords

end
