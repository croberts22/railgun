require './models/actor'
require './models/anime'
require './models/character'
require './models/manga'
require './services/mal_network_service'

module Railgun

  # Raised when there are any network errors.
  class NetworkError < StandardError
    attr_accessor :original_exception

    def initialize(message, original_exception = nil)
      @message = message
      @original_exception = original_exception
      super(message)
    end

    def to_s; @message; end
  end

end