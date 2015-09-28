module Storage
  class Report
      include DataMapper::Resource

      property :id,          Serial
      property :url,         Text
      property :ip,          String
      property :time,        Integer
      property :links_count, Integer

      has n, :headers
      has n, :links
  end
end
