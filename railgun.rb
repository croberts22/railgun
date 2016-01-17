require_relative 'models/actor'
require_relative 'models/anime'
require_relative 'models/character'
require_relative 'models/manga'
require_relative 'services/mal_network_service'

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