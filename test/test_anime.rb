require File.dirname(__FILE__) + '/test_helper'
require_relative '../app'

class TestAnime < Test::Unit::TestCase
  include Rack::Test::Methods

  # def app
  #   Sinatra::Application
  # end
  #
  # def test_anime
  #   get '/1.0/anime/1'
  #   assert last_response.ok?
  # end

end