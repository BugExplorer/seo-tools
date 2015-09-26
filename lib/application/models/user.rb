module SEOTool
  class User
    include DataMapper::Resource

    # Here I'm using non encrypted password

    property :id,       Serial
    property :username, String, :required => true
    property :email,    String
    property :password, String, :length => 6..255
  end

  DataMapper.finalize.auto_upgrade!

  if User.count == 0
    @user = User.create(username: "admin",
                        email: "example@example.com",
                        password: "admin")
    @user.save
  end
end
