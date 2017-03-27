require_relative 'resource_scraper'

module Railgun

  ### AnimeScraper
  ### Takes a Nokogiri object and converts it into an Anime object.

  class AnimeScraper < ResourceScraper

    def parse_anime(nokogiri, anime)

      anime.id = parse_id(nokogiri)
      anime.name = parse_name(nokogiri)
      anime.synopsis = parse_synopsis(nokogiri)
      anime.rank = parse_rank(nokogiri)
      anime.image_url = parse_image_url(nokogiri)

      node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

      anime.other_names = parse_alternative_names(node)
      anime.type = parse_type(node)
      anime.episodes = parse_episode_count(node)
      anime.status = parse_status(node)
      anime.start_date = parse_airing_start_date(node)
      anime.end_date = parse_airing_end_date(node)
      anime.studios = parse_studios(node)
      anime.producers = parse_producers(node)
      anime.source = parse_source(node)
      anime.genres = parse_genres(node)
      anime.classification = parse_rating(node)
      anime.score = parse_score(node)
      anime.score_count = parse_score_count(node)
      anime.popularity_rank = parse_popularity_rank(node)
      anime.members_count = parse_member_count(node)
      anime.favorited_count = parse_favorite_count(node)
      anime.premiere_year = parse_premiere_year(node)
      anime.premiere_season = parse_premiere_season(node)
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

      reviews_h2 = node.at('//h2[text()="Reviews"]')
      if reviews_h2

        # Get all text between "Reviews</h2>" and the next </h2> tag.
        matched_data = reviews_h2.parent.to_s.match(%r{Reviews</h2>(.+?)<h2>}m)
        if matched_data

          # Translate the captured string back into HTML so we can iterate upon it easier.
          # This is preferred versus attempting to iterate against a preset condition against
          # the entire page, since the outline could potentially change at any time (and it
          # would suck if this while loop kept going endlessly).

          # FIXME: This isn't the right regex, but will suffice for now. Having trailing \t\t\t\t at the beginning.
          data = matched_data[1].gsub(/>\s+</, '><')
          reviews = Nokogiri::HTML(data)

          anime.reviews = parse_reviews(reviews)


        end
      end

      anime.recommendations = parse_recommendations(node, anime.id)

    end


    def parse_id(nokogiri)
      anime_id_input = nokogiri.at('input[@name="aid"]')
      if anime_id_input
        id = anime_id_input['value'].to_s
      else
        details_link = nokogiri.at('//a[text()="Details"]')
        id = details_link['href'][%r{http[s]?://myanimelist.net/anime/(\d+)/.*?}, 1].to_s
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
        start_date = parse_start_date(airdates_text)

        start_date
      end
    end

    def parse_airing_end_date(nokogiri)
      if (node = nokogiri.at('//span[text()="Aired:"]')) && node.next
        airdates_text = node.next.text.strip
        end_date = parse_end_date(airdates_text)

        end_date
      end
    end

    def parse_rating(nokogiri)
      if (node = nokogiri.at('//span[text()="Rating:"]')) && node.next
        classification = node.next.text.strip

        classification
      end
    end

    def parse_premiere_url(nokogiri)
      if (node = nokogiri.at('//span[text()="Premiered:"]')) && node.next.next

        premiere_href = node.next.next.attribute('href')
        return unless premiere_href != nil

        matches = node.next.next.attribute('href').to_s.match(%r{/season/(\d+)/([A-z]+)})
        year = matches[1].to_i
        season = matches[2]

        [year, season]
      end
    end

    def parse_premiere_year(nokogiri)
      premiere_group = parse_premiere_url(nokogiri)
      premiere_group.first unless premiere_group.nil?
    end

    def parse_premiere_season(nokogiri)
      premiere_group = parse_premiere_url(nokogiri)
      premiere_group.last unless premiere_group.nil?
    end

    def parse_producers(nokogiri)
      if (node = nokogiri.at('//span[text()="Producers:"]')) && node.parent

        producers = []

        node.parent.search('a').each do |a|

          url = a.attribute('href').to_s
          name = a.attribute('title').to_s

          if name.empty?
            break if a.text.to_s == 'add some'
          end

          if matches = url.match(%r{/producer/(\d+)/})
            id = matches[1].to_s
          end

          producer = { :id => id, :name => name, :url => url }
          producers << producer

        end

        producers
      end
    end

    def parse_studios(nokogiri)
      if (node = nokogiri.at('//span[text()="Studios:"]')) && node.parent

        studios = []
        node.parent.search('a').each do |a|

          url = a.attribute('href').to_s
          name = a.attribute('title').to_s

          if name.empty?
            break if a.text.to_s == 'add some'
          end

          if matches = url.match(%r{/producer/(\d+)/})
            id = matches[1].to_s
          end

          studio = { :id => id, :name => name, :url => url }
          studios << studio

        end

        studios
      end
    end

    def parse_source(nokogiri)

      source = nil

      if (node = nokogiri.at('span:contains("Source:")')) && node.next
        source = node.next.text.strip
      end

      source
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
        $1.scan(regex_pattern) do |url, anime_id, name|
          anime << {
              :id => anime_id.to_s,
              :name => name,
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
        summary_stats[:in_progress] = node.next.text.strip.gsub(',','').to_i
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
        summary_stats[:planned] = node.next.text.strip.gsub(',','').to_i
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