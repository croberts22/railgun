# Railgun
#
# Author: Corey Roberts
# Description: An extension to the MyAnimeList API.
# Version: 0.1

require_relative 'models/resource'
require_relative 'models/person'
require_relative 'models/anime'
require_relative 'models/character'
require_relative 'models/manga'
require_relative 'models/review'
require_relative 'models/user'
require_relative 'services/mal_network_service'
require_relative 'utilities/logger'

module Railgun

  # Current API version.
  API_VERSION = '1.1'

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

  # Raised when a resource cannot be found.
  class NotFoundError < StandardError
    attr_accessor :original_exception

    def initialize(message, original_exception = nil)
      @message = message
      @original_exception = original_exception
      super(message)
    end
    def to_s; @message; end
  end

end