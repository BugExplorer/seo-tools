ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'lib/report'
require_relative 'lib/reports_handler'
require_relative 'app'

run App
