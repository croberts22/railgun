require_relative 'base_scraper'

module Railgun

  ### MangaScraper
  ### Takes a Nokogiri object and converts it into a Manga object.

  class MangaScraper < BaseScraper

    def parse_manga(nokogiri, manga)
      # TODO
    end

    def self.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)
      manga = []
      html_string.match(string_to_match)
      $1.scan(regex_pattern) do |url, manga_id, title|
        manga << {
            :manga_id => manga_id,
            :title => title,
            :url => url
        }
      end

      manga
    end

  end

end