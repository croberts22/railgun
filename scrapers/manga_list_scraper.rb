require_relative 'list_scraper'

module Railgun

  class MangaListScraper < ListScraper

    def parse_row(nokogiri, list_type)
      # Each row has five objects, three of which are useful:
      # 1: Rank
      # 2: Image, Name, Type (Volume Count), Publish Date, Members
      # 3: Score

      name = parse_name(nokogiri)
      url = parse_url(nokogiri)
      id = parse_id('manga', url)
      image_url = parse_image_url('manga', nokogiri)
      type = parse_type(nokogiri)
      rank = parse_rank(nokogiri)
      score = parse_score(nokogiri)
      volumes = parse_volumes(nokogiri)
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

          volumes: volumes,
          start_date: start_date,
          end_date: end_date,

          stats: {
              score: score,
              rank_type => rank,
              member_count: member_count
          }
      }

    end

    # NOTE: The following need to be overridden because the format differs from anime.
    # This does not have an additional embed inside a div after the detail div.
    # Who knows why they did this...
    def parse_name(nokogiri)
      name_element = nokogiri.at('td[2] div[@class="detail"] a')
      name_element.text.strip
    end

    def parse_url(nokogiri)
      url_element = nokogiri.at('td[2] div[@class="detail"] a')
      url_element['href']
    end

    def parse_type(nokogiri)
      type_element = parse_metadata(nokogiri).first

      # We anticipate something of the format:
      # Manga (24 vols)
      # However, sometimes volumes may be undefined (?).
      $1 if type_element.match %r{([a-zA-Z]+) \(([0-9]+|\?) vols\)}
    end

    def parse_volumes(nokogiri)
      type_element = parse_metadata(nokogiri).first

      # We anticipate something of the format:
      # Manga (24 vols)
      # However, sometimes volumes may be undefined (?).
      # Return 0 in this instance.
      if type_element.match %r{[a-zA-Z]+ \(([0-9]+) vols\)}
        $1.to_i
      else
        0
      end
    end

    # Takes a list type param and converts it to the appropriate
    # JSON key. This is a _safe_ method in that it will default
    # to 'rank' if the list_type does not match any appropriate
    # key (however, this should have already been guarded before the request,
    # so you must have _really_ messed up if you got to this state).
    def rank_key(list_type)

      # Available options: 'all', 'manga', 'novels', 'oneshots', 'doujinshi', 'manhwa', 'manhua', 'popular', 'favorite'.
      case list_type
        when 'all'
          'rank'
        when 'manga'
          'manga_rank'
        when 'novels'
          'novel_rank'
        when 'oneshots'
          'oneshot_rank'
        when 'doujinshi'
          'doujin_rank'
        when 'manhwa'
          'manhwa_rank'
        when 'manhua'
          'manhua_rank'
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