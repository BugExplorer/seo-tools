class ReportsHandler
  def initialize(path)
    @files = Dir.entries(path).delete_if { |x| !(x =~ /html/) }
    puts @files
  end

  def generate()
    _data = []

    unless @files.nil?
      @files.each do |file|
        _data << [
          # Site url
          file.gsub(/_.+/, ''),
          # Gets formatted creation time
          Time.at(file.gsub(/.+_/, '').to_i).strftime("%e %B %Y"),
          # File path
          file
        ]
      end
    end

    _data
  end
end
