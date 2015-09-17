require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'lib/report'
require_relative 'lib/view'
require_relative 'app'

run App
