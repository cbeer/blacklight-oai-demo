require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
  t.rcov = true
end