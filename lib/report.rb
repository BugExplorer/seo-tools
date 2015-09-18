class Report
  attr_reader :url, :title, :links, :headers, :ip
  def initialize(url)
    @url = cleanUrl(url)
  end

  def generate()
    # c = Curl::Easy.perform("http://www.google.co.uk")
    # puts c.body_str

    # Get response using Curl
    @response = Curl::Easy.new("http://" + @url)  do |curl|
      curl.follow_location = true
    end
    # enables both deflate and gzip compression of responses
    @response.encoding = ''
    @response.perform
    @ip = @response.primary_ip

    # Convert headers string to the Hash
    @headers = @response.header_str.split(/[\r\n]+/).map(&:strip)
    @headers = Hash[@headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]

    # Generate doc for parsing
    _doc = Nokogiri::HTML(@response.body_str)

    # Parse all the things
    @title = _doc.css('title').text
    @links = _doc.css('a')

    # Links on the site can be without 'http://site_url.com' part
    # Or without rel and target
    @links.each do |link|

      link[:href] = "http://" + @url.to_s + link[:href].to_s unless
        (link[:href] =~ /http(s*):\/\/(www\.)*/) ||
        (link[:href] =~ /^mailto:/)

      link[:rel]    ||= 'None'
      link[:target] ||= '_self'
    end

    # View generating

    _layout = File.open("./views/layout.slim", "rb").read
    # Create new template object with the layout
    _l = Slim::Template.new { _layout }
    _body = Slim::Template.new("./views/report.slim").render(self)

    # Mix layout and body templates
    File.open("./public/reports/#{@url}_#{Time.now.to_i}.html", 'w') do |f|
      f.write _l.render { _body }
    end
  end

  # Cleans request url from 'http://' at the start and from '/' at the end
  def cleanUrl(url)
    if url[-1].eql?("/")
      url = url[0..-2]
    end
    url = url.gsub(/http(s*):\/\/(www\.)*/, '')
  end

end
