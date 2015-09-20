require 'reports_handler'

RSpec.describe ReportsHandler do
  before do
    @file = File.open("./public/reports/example.com_1442683187.html", 'w')
  end

  context "with valid path" do
    it "returns an array of hashes" do      
      expect(ReportsHandler.new('./public/reports/').create).to include (
         {:url  => "example.com",
           :time => "19 September 2015 17:19",
           :path => "example.com_1442683187.html"}
      )      
    end
  end

  context "with no path" do
    it "raises an exception" do
      expect { ReportsHandler.new }.to raise_exception (StandardError)
    end
  end

  after do
    @file.close
    FileUtils.rm_r './public/reports/example.com_1442683187.html' 
  end
end
