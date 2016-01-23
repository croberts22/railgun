require_relative 'base_scraper'

module Railgun

  ### MangaScraper
  ### Takes a Nokogiri object and converts it into a Manga object.

  class MangaScraper < BaseScraper

    def self.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)
      html_string.match(string_to_match)
      $1.scan(%r{regex_pattern}) do |url, manga_id, title|
        return {
            :manga_id => manga_id,
            :title => title,
            :url => url
        }
      end
    end

  end

end