require_relative 'list_scraper'

module Railgun

  class AnimeListScraper < ListScraper

    def parse_row(nokogiri, list_type)
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

      rank_type = ''

      # Available options: 'all', 'airing', 'upcoming', 'tv', 'movie', 'ova', 'special', 'popular', 'favorite'.
      case list_type
        when 'all'
          rank_type = 'rank'
        when 'airing'
          rank_type = 'airing_rank'
        when 'upcoming'
          rank_type = 'upcoming_rank'
        when 'tv'
          rank_type = 'tv_rank'
        when 'movie'
          rank_type = 'movie_rank'
        when 'ova'
          rank_type = 'ova_rank'
        when 'special'
          rank_type = 'special_rank'
        when 'popular'
          rank_type = 'popularity_rank'
        when 'favorite'
          rank_type = 'favorited_rank'
        else

      end

      {
          id: id,
          name: name,
          type: type,
          url: url,
          image_url: image_url,

          episodes: episodes,
          start_date: start_date,
          end_date: end_date,

          stats: {
              rank_type => rank,
              member_count: member_count
          }
      }

    end

  end

end