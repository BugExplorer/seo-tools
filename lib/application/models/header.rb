module Storage
  class Header
      include DataMapper::Resource

      property :id,   Serial
      property :name, Text
      property :text, Text
      belongs_to :report

  end
end
