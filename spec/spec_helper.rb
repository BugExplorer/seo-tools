# Configure Rack Envinronment
ENV['RACK_ENV'] = "test"

require File.expand_path('../../config/environment',  __FILE__)


RSpec.configure do |config|
  require 'rack/test'
  include Rack::Test::Methods

  require 'webmock/rspec'
  WebMock.disable_net_connect!

  def app
    SEOTool::Application.new
  end

  # == Mock Framework
  config.mock_with :rspec

  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.before(:each) do
    stub_request(:any, "http://example.spec").to_return(:body => "abc",
                 :status => 200, :headers => { 'Content-Length' => "3" })
  end

  config.after(:all) do
    # Remove temporary files
    FileUtils.rm_r Dir.glob('./public/reports/example.spec*')
    DatabaseCleaner.clean
  end
end
