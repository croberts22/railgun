require_relative 'base_scraper'

module Railgun

  ### MangaScraper
  ### Takes a Nokogiri object and converts it into a Manga object.

  class MangaScraper < BaseScraper

    def parse_manga(nokogiri, manga)

      manga.id = parse_id(nokogiri)
      manga.title = parse_title(nokogiri)
      manga.synopsis = parse_synopsis(nokogiri)
      manga.rank = parse_rank(nokogiri)
      manga.image_url = parse_image_url(nokogiri)

      node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

      manga.other_titles = parse_alternative_titles(node)
      manga.type = parse_type(node)
      manga.volumes = parse_volume_count(node)
      manga.chapters = parse_chapter_count(node)
      manga.status = parse_status(node)
      manga.start_date = parse_publishing_start_date(node)
      manga.end_date = parse_publishing_end_date(node)
      manga.authors = parse_authors(node)
      manga.serialization = parse_serialization(node)
      manga.genres = parse_genres(node)
      manga.score = parse_score(node)
      manga.score_count = parse_score_count(node)
      manga.popularity_rank = parse_popularity_rank(node)
      manga.members_count = parse_member_count(node)
      manga.favorited_count = parse_favorite_count(node)
      manga.tags = parse_tags(node)

      node = nokogiri.xpath('//div[@id="content"]/table/tr/td/div')

      manga.additional_info_urls = parse_additional_info_urls(node)

      related_manga_h2 = node.at('//h2[text()="Related Manga"]')
      if related_manga_h2

        # Get all text between <h2>Related Manga</h2> and the next <h2> tag.
        match_data = related_manga_h2.parent.to_s.match(%r{</div>Related Manga</h2>(.+?)<h2>}m)
        if match_data
          related_manga_text = match_data[1]
          manga.anime_adaptations = parse_anime_adaptations(related_manga_text)
          manga.prequels = parse_prequels(related_manga_text)
          manga.sequels = parse_sequels(related_manga_text)
          manga.side_stories = parse_side_stories(related_manga_text)
          manga.parent_story = parse_parent_story(related_manga_text)
          manga.spin_offs = parse_spin_offs(related_manga_text)
          manga.summaries = parse_summaries(related_manga_text)
          manga.alternative_versions = parse_alternative_versions(related_manga_text)
          manga.alternative_settings = parse_alternative_settings(related_manga_text)
          manga.full_stories = parse_full_stories(related_manga_text)
          manga.others = parse_other(related_manga_text)
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

          manga.reviews = parse_reviews(reviews)


        end
      end

    end

    def parse_id(nokogiri)
      manga_id_input = nokogiri.at('input[@name="mid"]')
      if manga_id_input
        id = manga_id_input['value'].to_s
      else
        details_link = nokogiri.at('//a[text()="Details"]')
        id = details_link['href'][%r{http[s]?://myanimelist.net/manga/(\d+)/.*?}, 1].to_s
      end

      id
    end

    def parse_volume_count(nokogiri)
      if (node = nokogiri.at('//span[text()="Volumes:"]')) && node.next
        volumes = node.next.text.strip.gsub(',', '').to_i
        volumes = nil if volumes == 0

        volumes
      end
    end

    def parse_chapter_count(nokogiri)
      if (node = nokogiri.at('//span[text()="Chapters:"]')) && node.next
        chapters = node.next.text.strip.gsub(',', '').to_i
        chapters = nil if chapters == 0

        chapters
      end
    end

    def parse_publishing_start_date(nokogiri)
      if (node = nokogiri.at('//span[text()="Published:"]')) && node.next
        airdates_text = node.next.text.strip
        start_date = parse_start_date(airdates_text)

        start_date
      end
    end

    def parse_publishing_end_date(nokogiri)
      if (node = nokogiri.at('//span[text()="Published:"]')) && node.next
        airdates_text = node.next.text.strip
        end_date = parse_end_date(airdates_text)

        end_date
      end
    end

    def parse_authors(nokogiri)
      if (node = nokogiri.at('//span[text()="Authors:"]')) && node.parent

        authors = []

        node.parent.children.each do |e|

          if e['href']
            name = e.text
            url = e['href']
            id = /\/(\d+)\//.match(url)[1]

            if match = /\((.+)\)/.match(e.next.text)
              type = match[1].to_s

              authors.push({
                               :id => id,
                               :name => name,
                               :responsibility => type.strip,
                               :url => url
                           })

            end

          end

        end

        authors
      end
    end

    def parse_serialization(nokogiri)
      if (node = nokogiri.at('//span[text()="Serialization:"]'))
        serialization = node.parent.search('a').first
        url = serialization.attribute('href').to_s
        name = serialization.attribute('title').to_s
        id = /\/(\d+)\//.match(url)[1]


        { :id => id, :name => name, :url => url }
      end
    end

    def parse_anime_adaptations(html_string)
      require_relative 'anime_scraper'
      string_to_match = /Adaptation:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/anime/(\d+)/.*?)">(.+?)</a>}

      anime = AnimeScraper::generate_anime_from_pattern(html_string, string_to_match, regex_pattern)

      anime
    end

    def parse_prequels(html_string)
      string_to_match = /Prequel:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def parse_sequels(html_string)
      string_to_match = /Sequel:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def parse_side_stories(html_string)
      string_to_match = /Side story:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def parse_parent_story(html_string)
      string_to_match = /Parent story:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga.first
    end

    def parse_spin_offs(html_string)
      string_to_match = /Spin-off:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def parse_summaries(html_string)
      string_to_match = /Summary:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def parse_alternative_versions(html_string)
      string_to_match = /Alternative version?:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def parse_alternative_settings(html_string)
      string_to_match = /Alternative setting:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def parse_full_stories(html_string)
      string_to_match = /Full story:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def parse_other(html_string)
      string_to_match = /Other:\<\/td\>(.+?)\<\/td\>/m
      regex_pattern = %r{<a href="(/manga/(\d+)/.*?)">(.+?)</a>}

      manga = self.class.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)

      manga
    end

    def self.generate_manga_from_pattern(html_string, string_to_match, regex_pattern)
      manga = []
      if html_string.match(string_to_match)
        $1.scan(regex_pattern) do |url, manga_id, title|
          manga << {
              :id => manga_id.to_s,
              :title => title,
              :url => url
          }
        end
      end

      manga
    end

    # FIXME: Ripped from umalapi. This should be revisited.
    # TODO: Consolidate with AnimeScraper implementation, as these are virtually identical.
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

      if (node = left_column_nodeset.at('//span[text()="Reading:"]')) && node.next
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
      if (node = left_column_nodeset.at('//span[text()="Plan to Read:"]')) && node.next
        summary_stats[:planned] = node.next.text.strip.gsub(',','').to_i
      end
      if (node = left_column_nodeset.at('//span[text()="Total:"]')) && node.next
        summary_stats[:total] = node.next.text.strip.gsub(',','').to_i
      end

      summary_stats
    end

  end

end