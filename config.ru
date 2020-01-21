require 'rubygems'
require 'bundler'
Bundler.require # Bundler.require scans our Gemfile and connects everything in here. 

require './app'

run App.new