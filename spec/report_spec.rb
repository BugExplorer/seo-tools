require 'report'

RSpec.describe Report do
  context "with empty url" do
    it "raises an exception" do
      expect { Report.new }.to raise_exception (StandardError)
    end
  end

  context "with valid url" do
    it "parses page title" do
      uri = URI("http://example.org")
      report = Report.new(uri.to_s)
      report.generate
      expect(report.headers).to include("Content-Length" => "3")
    end
  end

  context "url with some slashes at the end" do
    it do
      expect( Report.new("valid.com/////").url ).to eq ("valid.com")
    end 
  end
end
