require 'nokogiri'

module Railgun

  class Anime

    def self.scrape(id, options)

      anime = Anime.new

      puts 'Scraping anime...'

      nokogiri = MALNetworkService.nokogiri_from_request("http://myanimelist.net/anime/#{id}")

      anime

    end


  end

  class AnimeScraper

    def parse_anime(nokogiri)

    end


    def parse_title(nokogiri)
      # Title and rank.
      # anime.title = doc.at('h1 span').text

      nokogiri.at('h1 span').text
    end


  end

end