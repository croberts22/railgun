require 'test/unit'
require 'rack/test'
require 'sinatra'

class AnimeTests < Test::Unit::TestCase
  include Rack::Test::Methods

  # def app
  #   Sinatra::Application
  # end

  # def test_anime
  #   get '/'
  #   assert last_response.ok?
  # end

end