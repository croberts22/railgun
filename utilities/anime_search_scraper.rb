require_relative 'search_scraper'

module Railgun

  class AnimeSearchScraper < SearchScraper

    def parse_row(nokogiri)

      # There are five objects per row, with data in the following order:
      # 1: Image
      # 2: Title, Synopsis
      # 3: Type
      # 4: Number of episodes
      # 5: Average Score

      image_url = parse_image_url('anime', nokogiri)
      name = parse_name(nokogiri)
      url = parse_url(nokogiri)
      id = parse_id('anime', url)
      synopsis = parse_synopsis(nokogiri)

      {
          id: id,
          name: name,
          url: url,
          image_url: image_url,
          synopsis: synopsis
      }
    end

  end

end