module SEOTool
  class Report
    attr_reader :url, :ip, :time, :links, :headers

    def initialize(options = {})
      @url = options[:url]
      @ip = options[:ip]
      @time = options[:time]
      @links = options[:links]
      @headers = options[:headers]
    end
  end
end
