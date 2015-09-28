module Storage
  class Link
    include DataMapper::Resource

    property :id,      Serial
    property :href,    Text
    property :content, Text
    property :rel,     Text
    property :target,  Text

    belongs_to :report

  end
end
