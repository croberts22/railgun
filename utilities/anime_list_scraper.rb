require_relative 'list_scraper'

module Railgun

  class AnimeListScraper < ListScraper

    def parse_row(nokogiri)
      # Each row has five objects, three of which are useful:
      # 1: Rank
      # 2: Image, Name, Type (Episode Count), Air Date, Members
      # 3: Score

      name = parse_name(nokogiri)
      url = parse_url(nokogiri)
      id = parse_id('anime', url)
      image_url = parse_image_url('anime', nokogiri)
      type = parse_type(nokogiri)
      rank = parse_rank(nokogiri)
      episodes = parse_episodes(nokogiri)
      start_date = parse_start_date(nokogiri)
      end_date = parse_end_date(nokogiri)
      member_count = parse_member_count(nokogiri)

      {
          id: id,
          name: name,
          url: url,
          image_url: image_url,
          type: type,
          episodes: episodes,

          start_date: start_date,
          end_date: end_date,
          member_count: member_count,

          rank: rank
      }

    end

  end

end