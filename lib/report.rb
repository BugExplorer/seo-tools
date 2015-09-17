class Report
  def initialize(url)
    @url = cleanUrl(url)
  end

  def generate()
    _response = HTTParty.head("http://" + @url)  

    _doc = Nokogiri::HTML(_response.body)

    # Parse all the things
    title = _doc.css('title').text
    links = _doc.css('a')
    headers = _response.headers

    return [title, links, headers, @url]
  end

  # Cleans url from 'http://' at the start and from '/' at the end
  def cleanUrl(url)
    if url[-1].eql?("/")
      url = url[0..-2]
    end
    url = url.gsub(/http(s*):\/\/(www\.)*/, '')
  end

end
