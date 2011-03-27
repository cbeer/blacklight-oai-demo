# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.11' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/blacklight/vendor/plugins/engines/boot')

Rails::Initializer.run do |config|
  config.plugin_paths += ["#{RAILS_ROOT}/vendor/plugins/blacklight/vendor/plugins"]
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.autoload_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "authlogic", :version => '2.1.2'

  #unicode is used by refworks export to force C form normalization, which
  #refworks wants.
  config.gem 'unicode'
  
  # these are used for testing (rake solr:spec, which ends up running in the "development" environment)
  config.gem 'rspec', :version=>'~>1.3.0', :lib=>false
  config.gem 'rspec-rails', :version=>'~>1.3.2', :lib=>false
  
  config.gem 'webrat', :version=>'0.7.0'
  config.gem 'cucumber', :version=>'~>0.6.2'
  config.gem 'rcov', :version=>'0.9.7.1'
  
  
  # these are auto-generated by cucumber and usually in the environments/cucumber.rb file
  # -- but having them here makes it easy to do rake gems:install without a RAILS_ENV=cucumber
  config.gem 'cucumber-rails',   :lib => false, :version => '~>0.2.4'
  config.gem 'database_cleaner', :lib => false, :version => '>=0.4.3'
  config.gem 'webrat',           :lib => false, :version => '>=0.6.0'
  config.gem 'rspec',            :lib => false, :version => '~>1.3.0'
  config.gem 'rspec-rails',      :lib => false, :version => '~>1.3.2'
  
  # rdoc and haml are required by hana
  config.gem 'rdoc', :version=>'2.4.3'
  config.gem 'haml', :version=>'2.2.19'
  
  # hanna is only needed for generating rdocs
  config.gem 'hanna', :lib=>'hanna/rdoctask', :source=>'http://gemcutter.org', :version=>'0.1.12'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end
