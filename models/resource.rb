require 'nokogiri'

module Railgun

  class Resource

    attr_accessor :id, :name, :url, :image_url

    # def initialize(id, name, url, image_url)
    #   # Instance variables
    #   @id = id
    #   @name = name
    #   @url = url
    #   @image_url = image_url
    # end

    def attributes
      # MUST OVERRIDE
    end

    def to_json(*args)
      attributes.to_json(*args)
    end

  end

end