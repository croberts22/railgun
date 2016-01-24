require 'coveralls'
Coveralls.wear! do
  add_filter '/test/'
end
SimpleCov.command_name 'Unit Tests'

require 'test/unit'
require 'rack/test'
require 'sinatra'

require_relative '../railgun'
