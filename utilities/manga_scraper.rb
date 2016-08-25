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
      manga.genres = parse_genres(node)
      manga.members_score = parse_score(node)
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

    end

    def parse_id(nokogiri)
      manga_id_input = nokogiri.at('input[@name="mid"]')
      if manga_id_input
        id = manga_id_input['value'].to_i
      else
        details_link = nokogiri.at('//a[text()="Details"]')
        id = details_link['href'][%r{http[s]?://myanimelist.net/manga/(\d+)/.*?}, 1].to_i
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
        start_date = BaseScraper::parse_start_date(airdates_text)

        start_date
      end
    end

    def parse_publishing_end_date(nokogiri)
      if (node = nokogiri.at('//span[text()="Published:"]')) && node.next
        airdates_text = node.next.text.strip
        end_date = BaseScraper::parse_end_date(airdates_text)

        end_date
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
              :manga_id => manga_id,
              :title => title,
              :url => url
          }
        end
      end

      manga
    end

  end

end