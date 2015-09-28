module SEOTool
  class User
    include DataMapper::Resource

    # Here I'm using non encrypted password

    property :id,       Serial
    property :username, String, :required => true
    property :email,    String
    property :password, String, :length => 6..255
  end


end
