require_relative '../scrapers/scraper'

module Railgun

  class PersonScraper < Scraper

    def parse_id(nokogiri)
      id = nil

      metadata_url = nokogiri.at('meta[@property="og:url"]').attribute('content').to_s
      if metadata_url
        id = metadata_url[%r{http[s]?://myanimelist.net/character/(\d+)/.*?}, 1]
      end

      id
    end

    def parse_name(nokogiri)
      nokogiri.at('h1').text
    end

    def parse_url(nokogiri)
      nokogiri.at('meta[@property="og:url"]').attribute('content').to_s
    end

    def parse_image_url(nokogiri)
      nokogiri.at('div#content tr td div img').attribute('src').to_s
    end

  end

end