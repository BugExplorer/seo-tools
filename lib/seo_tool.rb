require "./lib/application/application"
require "./lib/application/report"
require "./lib/application/reports_controller"
require "./lib/application/link"
require "./lib/storage/storage_provider"
require "./lib/storage/files_provider"
require "./lib/storage/data_base_provider"


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
