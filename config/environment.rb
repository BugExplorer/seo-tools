$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require File.expand_path('../boot', __FILE__)

ENV['RACK_ENV'] ||= 'development'
ENV['TMPDIR'] ||= File.expand_path('../../tmp', __FILE__)

ENV['STORAGE'] = 'db' # 'db' or 'file'

ENV['STORAGE'] = 'file' if ENV['RACK_ENV'] == 'test'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, ENV['RACK_ENV']) if defined?(Bundler)

require "seo_tool"
