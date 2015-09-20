class Report
  attr_reader :url, :title, :links, :headers, :ip
  def initialize(url)
    if url
      @url = cleanUrl(url)
    else
      raise StandardError, '@url is empty'
    end
  end

  def generate()    
    if _body_str = get_response 
      parse(_body_str)      
    end    
  end

  private
    def get_response
      # Get response using Curl
      _response = Curl::Easy.new(@url)  do |curl|
        curl.follow_location = true
      end
      # enables both deflate and gzip compression of responses
      _response.encoding = ''
      _response.perform
      @ip = _response.primary_ip

      # Convert headers string to the Hash
      @headers = _response.header_str.split(/[\r\n]+/).map(&:strip)
      @headers = Hash[@headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]

      # Return doc with right encoding
      _body = _response.body_str
      unless _body.force_encoding("UTF-8").valid_encoding?
        _body.force_encoding("cp1251")
      else
        _body.force_encoding("UTF-8")
      end
    end

    def parse(body) 
      _doc = Nokogiri::HTML(body)

      # Parse all the things
      @title = _doc.css('title').text
      @links = _doc.css('a')

      # Links on the site can be without 'http://site_url.com' part
      # Or without rel and target
      @links.each do |link|
        link[:href] = "http://" + @url.to_s + link[:href].to_s unless
          (link[:href] =~ /http(s*):\/\/(www\.)*/) ||
          (link[:href] =~ /^mailto:/)
      end

      create_view_file
    end

    def create_view_file() 
      _l = File.open("./views/layout.slim", "rb").read
      # Create new template object with the layout
      _layout = Slim::Template.new { _l }
      _content = Slim::Template.new("./views/report.slim").render(self)

      # Mix layout and body templates
      File.open("./public/reports/#{@url}_#{Time.now.to_i}.html", 'w') do |f|
        f.write _layout.render { _content }
      end
    end

    # Cleans request url from 'http://' at the start and from any amount of '/' at the end
    def cleanUrl(url)
      url = url.gsub(/http(s*):\/\/(www\.)*/, '')
      url.gsub(/\/+$/, '')
    end
end
