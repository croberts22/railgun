require_relative 'base_scraper'

module Railgun

  ### AnimeScraper
  ### Takes a Nokogiri object and converts it into an Anime object.

  class AnimeScraper < BaseScraper

    def parse_anime(nokogiri, anime)

      anime.id = parse_id(nokogiri)
      anime.title = parse_title(nokogiri)
      anime.synopsis = parse_synopsis(nokogiri)
      anime.rank = parse_rank(nokogiri)
      anime.image_url = parse_image_url(nokogiri)

      node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

      anime.other_titles = parse_alternative_titles(node)
      anime.type = parse_type(node)
      anime.episodes = parse_episode_count(node)
      anime.status = parse_status(node)
      anime.start_date = parse_airing_start_date(node)
      anime.end_date = parse_airing_end_date(node)
      anime.genres = parse_genres(node)
      anime.classification = parse_rating(node)
      anime.members_score = parse_score(node)
      anime.popularity_rank = parse_popularity_rank(node)
      anime.members_count = parse_member_count(node)
      anime.favorited_count = parse_favorite_count(node)
      anime.tags = parse_tags(node)

      node = nokogiri.xpath('//div[@id="content"]/table/tr/td/div')

      anime.additional_info_urls = parse_additional_info_urls(node)

      related_anime_h2 = node.at('//h2[text()="Related Anime"]')
      if related_anime_h2

        # Get all text between <h2>Related Anime</h2> and the next <h2> tag.
        match_data = related_anime_h2.parent.to_s.match(%r{</div>Related Anime</h2>(.+?)<h2>}m)
        if match_data
          related_anime_text = match_data[1]
          anime.manga_adaptations = parse_manga_adaptations(related_anime_text)
          anime.prequels = parse_prequels(related_anime_text)
          anime.sequels = parse_sequels(related_anime_text)
          anime.side_stories = parse_side_stories(related_anime_text)
          anime.parent_story = parse_parent_story(related_anime_text)
          anime.character_anime = parse_character_anime(related_anime_text)
          anime.spin_offs = parse_spin_offs(related_anime_text)
          anime.summaries = parse_summaries(related_anime_text)
          anime.alternative_versions = parse_alternative_versions(related_anime_text)
          anime.alternative_settings = parse_alternative_settings(related_anime_text)
          anime.full_stories = parse_full_stories(related_anime_text)
          anime.others = parse_other(related_anime_text)
        end

      end


    end


    def parse_id(nokogiri)
      anime_id_input = nokogiri.at('input[@name="aid"]')
      if anime_id_input
        id = anime_id_input['value'].to_i
      else
        details_link = doc.at('//a[text()="Details"]')
        id = details_link['href'][%r{http://myanimelist.net/anime/(\d+)/.*?}, 1].to_i
      end

      id
    end

    def parse_episode_count(nokogiri)
      if (node = nokogiri.at('//span[text()="Episodes:"]')) && node.next
        episodes = node.next.text.strip.gsub(',', '').to_i
        episodes = nil if episodes == 0

        episodes
      end
    end

    def parse_airing_start_date(nokogiri)
      if (node = nokogiri.at('//span[text()="Aired:"]')) && node.next
        airdates_text = node.next.text.strip
        start_date = BaseScraper::parse_start_date(airdates_text)

        start_date
      end
    end

    def parse_airing_end_date(nokogiri)
      if (node = nokogiri.at('//span[text()="Aired:"]')) && node.next
        airdates_text = node.next.text.strip
        end_date = BaseScraper::parse_end_date(airdates_text)

        end_date
      end
    end

    def parse_rating(nokogiri)
      if (node = nokogiri.at('//span[text()="Rating:"]')) && node.next
        classification = node.next.text.strip

        classification
      end
    end

    def parse_manga_adaptations(html_string)
      require_relative 'manga_scraper'
      string_to_match = /Adaptation:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = MangaScraper::generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def parse_prequels(html_string)
      string_to_match = /Prequel:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_sequels(html_string)
      string_to_match = /Sequel:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_side_stories(html_string)
      string_to_match = /Side story:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_parent_story(html_string)
      string_to_match = /Parent story:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime.first
    end

    def parse_character_anime(html_string)
      string_to_match = /Character:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_spin_offs(html_string)
      string_to_match = /Spin-off:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_summaries(html_string)
      string_to_match = /Summary:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_alternative_versions(html_string)
      string_to_match = /Alternative version?:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_alternative_settings(html_string)
      string_to_match = /Alternative setting:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_full_stories(html_string)
      string_to_match = /Full story:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_other(html_string)
      string_to_match = /Other:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = self.class.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def self.generate_anime_from_pattern(html_string, string_to_match, regex_pattern)
      anime = []
      if html_string.match(string_to_match)
        $1.scan(regex_pattern) do |url, anime_id, title|
          anime << {
              :anime_id => anime_id,
              :title => title,
              :url => url
          }
        end
      end

      anime
    end

    # FIXME: Ripped from umalapi. This should be revisited.
    def parse_summary_stats(nokogiri)

      summary_stats = {}

      # Summary Stats.
      # Example:
      # <div class="spaceit_pad"><span class="dark_text">Watching:</span> 12,334</div>
      # <div class="spaceit_pad"><span class="dark_text">Completed:</span> 59,459</div>
      # <div class="spaceit_pad"><span class="dark_text">On-Hold:</span> 3,419</div>
      # <div class="spaceit_pad"><span class="dark_text">Dropped:</span> 2,907</div>
      # <div class="spaceit_pad"><span class="dark_text">Plan to Watch:</span> 17,571</div>
      # <div class="spaceit_pad"><span class="dark_text">Total:</span> 95,692</div>

      left_column_nodeset = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

      if (node = left_column_nodeset.at('//span[text()="Watching:"]')) && node.next
        summary_stats[:watching] = node.next.text.strip.gsub(',','').to_i
      end
      if (node = left_column_nodeset.at('//span[text()="Completed:"]')) && node.next
        summary_stats[:completed] = node.next.text.strip.gsub(',','').to_i
      end
      if (node = left_column_nodeset.at('//span[text()="On-Hold:"]')) && node.next
        summary_stats[:on_hold] = node.next.text.strip.gsub(',','').to_i
      end
      if (node = left_column_nodeset.at('//span[text()="Dropped:"]')) && node.next
        summary_stats[:dropped] = node.next.text.strip.gsub(',','').to_i
      end
      if (node = left_column_nodeset.at('//span[text()="Plan to Watch:"]')) && node.next
        summary_stats[:plan_to_watch] = node.next.text.strip.gsub(',','').to_i
      end
      if (node = left_column_nodeset.at('//span[text()="Total:"]')) && node.next
        summary_stats[:total] = node.next.text.strip.gsub(',','').to_i
      end

      summary_stats
    end

    # FIXME: Ripped from umalapi. This should be revisited.
    def parse_score_stats(nokogiri)

      score_stats = {}

      # Summary Stats.
      # Example:
      # <tr>
      #   <td width="20">10</td>
      #	  <td>
      #     <div class="spaceit_pad">
      #       <div class="updatesBar" style="float: left; height: 15px; width: 23%;"></div>
      #       <span>&nbsp;22.8% <small>(12989 votes)</small></span>
      #     </div>
      #   </td>
      # </tr>

      left_column_nodeset = nokogiri.xpath('//table[preceding-sibling::h2[text()="Score Stats"]]')
      left_column_nodeset.search('tr').each do |tr|
        if (tr_array = tr.search('td')) && tr_array.count == 2
          name = tr_array[0].at('text()').to_s
          value = tr_array[1].at('div/span/small/text()').to_s

          if value.match %r{\(([0-9]+) votes\)}
            score_stats[name] = $1.to_i
          end

        end
      end

      score_stats
    end

  end

end