# DataBase configuration
DataMapper.setup(:default, 'postgres://sinatra:sinatra@localhost/project')

require "./lib/application/controllers/application"
require "./lib/application/controllers/reports_controller"
require "./lib/application/classes/report"
require "./lib/application/classes/report_link"
require "./lib/application/models/user"
require "./lib/storage/storage_provider"
require "./lib/storage/files_provider"
require "./lib/storage/data_base_provider"
require "./lib/storage/orm_provider"

DataMapper.finalize
DataMapper.auto_upgrade!

module SEOTool
  # Load configuration
  #
  def self.config
    @config ||= ENV['STORAGE'].strip.downcase
  end

  def self.root_path
    @root_path ||= Pathname.new(File.dirname(File.expand_path('../', __FILE__)))
  end
end
