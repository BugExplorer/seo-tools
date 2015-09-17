class View
  attr_reader :title, :links, :headers, :url

  def initialize(array)
    @title, @links, @headers, @url = array
  end

  def create
    # Generate the template
    _body = Slim::Template.new("./views/report.slim").render(self)

    File.open("./public/reports/#{@url}_#{Time.now.to_i}.html", 'w') {|f| f.write(_body) }
  end
end