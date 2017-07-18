require_relative '../scrapers/person_scraper'

module Railgun

  class Person < Resource

    attr_accessor :given_name, :family_name, :alternate_names, :birthday, :website, :favorited_count, :more_info
    attr_accessor :voice_acting_roles, :anime_staff_positions, :published_manga

    def alternate_names
      @alternate_names||= []
    end

    def voice_acting_roles
      @voice_acting_roles ||= []
    end

    def anime_staff_positions
      @anime_staff_positions ||= []
    end

    def published_manga
      @published_manga ||= []
    end

    def attributes
      {
          :id => id,
          :name => name,
          :url => url,
          :image_url => image_url,

          :given_name => given_name,
          :family_name => family_name,
          :alternate_names => alternate_names,

          :birthday => birthday,
          :website => website,
          :favorited_count => favorited_count,
          :more_info => more_info,

          :voice_acting_roles => voice_acting_roles,
          :anime_staff_positions => anime_staff_positions,
          :published_manga => published_manga
      }
    end


    ### Creation Methods

    def self.scrape(id)

      # Log::Logger.log(Severity.INFO, "Starting web scrape for id #{id}...")

      person = Person.new(id)
      nokogiri = MALNetworkService.nokogiri_from_request(MALNetworkService.person_request_for_id(id))

      scraper = PersonScraper.new

      scraper.scrape(nokogiri, person)

      person
    end

  end

end