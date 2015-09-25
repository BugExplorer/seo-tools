module SEOTool
  class ReportsController
    attr_reader :storage_provider

    def initialize()
      @storage_provider =
        if SEOTool.config == "db"
          Storage::DataBaseProvider.new
        elsif SEOTool.config == "file"
          Storage::FilesProvider.new
        end
      @links = []
    end

    def generate(url)
      @url = url
      _body_str = get_response
      parse_response _body_str
      _report = Report.new(url: cleanUrl(@url),
                           ip: @ip,
                           time: Time.now.to_i,
                           links: @links,
                           headers: @headers)

      @storage_provider.save_report _report
    end

    private
      def get_response
        # Get response using Curl
        _response = Curl::Easy.new(@url) do |curl|
          curl.follow_location = true
        end
        # enables both deflate and gzip compression of responses
        _response.encoding = ''
        _response.perform

        @ip = _response.primary_ip

        @headers = _response.header_str
        @headers = @headers.split(/[\r\n]+/).map(&:strip)
        @headers = Hash[@headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]

        # Return doc with valid encoding
        _body = _response.body_str
        unless _body.force_encoding("UTF-8").valid_encoding?
          _body.force_encoding("cp1251")
        else
          _body.force_encoding("UTF-8")
        end
      end

      def parse_response(body)
        _doc = Nokogiri::HTML(body)
        _links = _doc.css('a')

        # Links on the site can be without 'http://this_site.com' part
        _links.each do |link|
          unless (link[:href] =~ /http(s*):\/\/(www\.)*/) || (link[:href] =~ /^mailto:/)
            link[:href] = 'http://' + @url.to_s + link[:href].to_s
          end
          if SEOTool.config == "file"
            @links << Link.new(link[:href],
                               link.content,
                               link[:rel],
                               link[:target])
          else
            # In DataBase we don't store Link class objects
            @links << [link[:href],
                       link.content,
                       link[:rel],
                       link[:target]]
          end
        end
      end

      # Cleans request url from 'http://' at the start and from any amount of '/' at the end
      def cleanUrl(url)
        url = url.gsub(/http(s*):\/\/(www\.)*/, '')
        url.gsub(/\/+$/, '')
      end
  end
end
