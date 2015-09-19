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

  config.before(:all) do
    FileUtils.mkdir_p("./spec/tmp/") unless File.directory?("./spec/tmp/")
    # Creates empty dir for the ReportsHandler test
    FileUtils.mkdir_p("./spec/tmp/tmp") unless File.directory?("./spec/tmp/tmp")
    # File for ReportsHandler
    File.open("./spec/tmp/test.com_1442652783.html", 'w')
  end

  config.before(:each) do
    WebMock.disable_net_connect!(:allow => "example.wrong")
    stub_request(:any, "http://example.org").to_return(:body => "abc",
                 :status => 200, :headers => { 'Content-Length' => "3" })
  end

  config.after(:all) do
    # Remove temporary files
    FileUtils.rm_rf(Dir["./public/reports/example*"])
    FileUtils.rm_rf(Dir["./spec/tmp/"])
    WebMock.allow_net_connect!
  end
end
