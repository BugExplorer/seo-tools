# Configure Rack Envinronment
ENV['RACK_ENV'] = "test"

require File.expand_path('../../config/environment',  __FILE__)

require 'webmock/rspec'

RSpec.configure do |config|
  require 'rack/test'
  include Rack::Test::Methods
  WebMock.disable_net_connect!

  def app
    SEOTool::Application.new
  end

  # == Mock Framework
  config.mock_with :rspec

  config.before(:each) do
    stub_request(:any, "http://example.spec").to_return(:body => "abc",
                 :status => 200, :headers => { 'Content-Length' => "3" })
  end

  config.after(:all) do
    # Remove temporary files
    FileUtils.rm_r Dir.glob('./public/reports/example.spec*')
  end
end
