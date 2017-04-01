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

      rank_type = rank_key(list_type)

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

    # Takes a list type param and converts it to the appropriate
    # JSON key. This is a _safe_ method in that it will default
    # to 'rank' if the list_type does not match any appropriate
    # key (however, this should have already been guarded before the request,
    # so you must have _really_ messed up if you got to this state).
    def rank_key(list_type)

      # Available options: 'all', 'airing', 'upcoming', 'tv', 'movie', 'ova', 'special', 'popular', 'favorite'.
      case list_type
        when 'all'
          'rank'
        when 'airing'
          'airing_rank'
        when 'upcoming'
          'upcoming_rank'
        when 'tv'
          'tv_rank'
        when 'movie'
          'movie_rank'
        when 'ova'
          'ova_rank'
        when 'special'
          'special_rank'
        when 'popular'
          'popularity_rank'
        when 'favorite'
          'favorited_rank'
        else
          'rank'
      end

    end

  end

end