require 'coveralls'
Coveralls.wear! do
  add_filter '/test/'
end
SimpleCov.command_name 'Unit Tests'

require 'test/unit'
require 'rack/test'
require 'sinatra'
require 'sinatra/reloader'

require_relative '../railgun'
