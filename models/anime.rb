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



  end

end