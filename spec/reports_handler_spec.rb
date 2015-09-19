require 'reports_handler'

RSpec.describe ReportsHandler do
  context "with valid path" do
    it "returns an array of hashes" do
      expect(ReportsHandler.new('./spec/tmp/').create).to eq (
         [{:url  => "test.com",
           :time => "19 September 2015",
           :path => "test.com_1442652783.html"}]
      )
    end
  end

  context "with no path" do
    it "raises an exception" do
      expect { ReportsHandler.new }.to raise_exception (StandardError)
    end
  end
end
