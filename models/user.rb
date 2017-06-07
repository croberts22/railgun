require_relative 'resource'
require_relative '../scrapers/user_list_scraper'

module Railgun

  class User < Resource

    def self.scrape(id)

      # Log::Logger.log(Severity.INFO, "Starting web scrape for id #{id}...")

      # user = User.new
      # nokogiri = MALNetworkService.nokogiri_from_request(MALNetworkService.person_request_for_id(id))
      #
      # scraper = UserScraper.new
      #
      # user = scraper.scrape(nokogiri, user)
      #
      # user
    end

    def self.scrape_friends(id)
      nokogiri = MALNetworkService.nokogiri_from_request(MALNetworkService.user_friend_list_request_for_id(id))

      scraper = UserListScraper.new

      users = scraper.scrape(nokogiri)

      users
    end

  end

end