require 'nokogiri'

module Railgun

  class Resource

    attr_accessor :id, :name, :url, :image_url

    def initialize(id)
      # Instance variables
      @id = id
    end

    def attributes
      # MUST OVERRIDE
    end

    def to_json(*args)
      attributes.to_json(*args)
    end

  end

end