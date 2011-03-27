VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.stub_with :webmock
  c.ignore_localhost = true
end

Spec::Runner.configure do |c|
    c.extend VCR::RSpec::Macros
end

