ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems
require 'webmock/rspec'

require_relative "../app.rb"
require_relative "../lib/report.rb"
require_relative "../lib/reports_handler.rb"

RSpec.configure do |config|
  include Rack::Test::Methods

  def app
    App.new
  end

  config.mock_with :rspec

  config.before(:each) do
    WebMock.disable_net_connect!(:allow => "example.wrong")
    stub_request(:any, "http://example.org").to_return(:body => "abc",
                 :status => 200, :headers => { 'Content-Length' => "3" })
  end

  config.after(:all) do
    # Remove temporary files
    FileUtils.rm_r Dir.glob('./public/reports/example.org*')  
    WebMock.allow_net_connect!
  end
end
