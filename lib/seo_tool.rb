# DataBase configuration
if ENV['RACK_ENV'] == 'test'
  DataMapper.setup(:default, 'postgres://sinatra:sinatra@localhost/go')
else
  DataMapper.setup(:default, 'postgres://sinatra:sinatra@localhost/project')
end

require  'dm-migrations'

require "./lib/application/models/user"
require "./lib/application/controllers/application"
require "./lib/application/controllers/reports_controller"
require "./lib/application/classes/report"
require "./lib/application/classes/report_link"
require "./lib/storage/storage_provider"
require "./lib/storage/files_provider"
require "./lib/storage/data_base_provider"
require "./lib/application/models/link"
require "./lib/application/models/report"
require "./lib/application/models/header"
require "./lib/storage/orm_provider"

DataMapper.finalize.auto_migrate!

module SEOTool
  if User.count == 0
    @user = User.create(username: "admin",
                        email: "sebastiyan.michael@outlook.com",
                        password: "administrator")
    @user.save
  end

  # Load configuration
  #
  def self.config
    @config ||= ENV['STORAGE'].strip.downcase
  end

  def self.root_path
    @root_path ||= Pathname.new(File.dirname(File.expand_path('../', __FILE__)))
  end
end
