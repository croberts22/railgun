require 'coveralls'
Coveralls.wear!
SimpleCov.command_name 'Unit Tests'

require 'test/unit'
require 'rack/test'
require 'sinatra'

require_relative '../railgun'
