require 'rubygems'
require 'bundler'

Bundler.require
require './lib/seo_tool'
require './lib/application/controllers/application'

require ::File.expand_path('../config/environment',  __FILE__)

run SEOTool::Application
