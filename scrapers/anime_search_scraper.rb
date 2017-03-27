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
      type = parse_type(nokogiri)
      episodes = parse_episode_count(nokogiri)

      synopsis = parse_synopsis(nokogiri)

      # TODO: Consider making this a resource object.
      {
          id: id,
          name: name,
          url: url,
          image_url: image_url,
          type: type,
          episodes: episodes,

          synopsis: synopsis
      }
    end

    def parse_episode_count(nokogiri)
      parse_quantity(nokogiri)
    end

  end

end