require "spec_helper"

RSpec.describe Storage::FilesProvider do
  before do
    @files_provider = Storage::FilesProvider.new
  end

  describe "Class initialization" do
    it "creates reports directory" do
      expect(Dir.entries './public/').to include 'reports'
    end
  end

  describe "Getting all reports" do
    it "returns reports array" do
      # Stub reports directory content
      allow(Dir).to receive(:entries) { ['test.com_1443195933.html'] }
      _reports = @files_provider.get_all_reports
      expect(_reports).to include({:url=>"test.com",
                                   :time=>"25 September 2015 18:45",
                                   :guid=>"test.com_1443195933.html"})
    end
  end

  describe "Saving report" do
    it "creates view file" do
      _url = 'example.spec'
      _ip  = '127.0.0.1'
      _time = 1443198681
      _links = []
      _links << ::SEOTool::Link.new('test.com', 'test', '', '_blank')
      _headers = {"Date" => "Today", "Site-Content" => "Text"}

      _report = ::SEOTool::Report.new(url: _url,
                                      ip: _ip,
                                      time: _time,
                                      links: _links,
                                      headers: _headers)

      @files_provider.save_report(_report)
      expect(File.read('./public/reports/example.spec_1443198681.html')).
        to include("Site-Content")
    end
  end
end
