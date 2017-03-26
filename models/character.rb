require_relative 'resource'
require_relative '../scrapers/character_scraper'

module Railgun

  class Character < Resource

    attr_accessor :favorited_count, :nickname
    attr_accessor :anime, :manga, :actors, :biography


    def anime
      @anime ||= []
    end

    def manga
      @manga ||= []
    end

    def actors
      @actors ||= []
    end

    def attributes
      {
          :id => id,
          :name => name,
          :url => url,
          :image_url => image_url,

          :nickname => nickname,
          :favorited_count => favorited_count,
          :biography => biography,

          :actors => actors,
          :anime => anime,
          :manga => manga

      }
    end

    def to_json(*args)
      attributes.to_json(*args)
    end


    ### Creation Methods

    def self.scrape(id)

      # Log::Logger.log(Severity.INFO, "Starting web scrape for id #{id}...")

      character = Character.new
      nokogiri = MALNetworkService.nokogiri_from_request(MALNetworkService.character_request_for_id(id))

      scraper = CharacterScraper.new

      scraper.scrape(nokogiri, character)

      character
    end

  end

end