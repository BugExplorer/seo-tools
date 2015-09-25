require  'dm-migrations'

DataMapper.setup(:default, 'postgres://sinatra:sinatra@localhost/project')

class User
  include DataMapper::Resource
  property :id,       Serial
  property :username, String, :required => true
  property :email,    String
  property :password, String, :length => 6..255
end

DataMapper.finalize

configure :development do
    DataMapper.auto_upgrade!
end

if User.count == 0
  @user = User.create(username: "admin", email: "example@example.com", password: "admin")
  @user.save
end
