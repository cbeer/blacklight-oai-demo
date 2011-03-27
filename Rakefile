# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

# the default rake task
desc "run migrations and call solr:spec and solr:features"
task :default => "test"

# run migrations and call solr:spec and solr:features
desc 'run migrations and call solr:spec and solr:features'
task "test" => ["db:migrate", "spec", "cucumber"] do
  # ...
end

