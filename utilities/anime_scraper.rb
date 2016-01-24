require_relative 'base_scraper'
require_relative 'manga_scraper'

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


    def parse_title(nokogiri)
      # Title and rank.
      # anime.title = doc.at('h1 span').text

      nokogiri.at('h1 span').text
    end


    def parse_synopsis(nokogiri)
      synopsis_h2 = nokogiri.at('//h2[text()="Synopsis"]')
      synopsis = ''

      if synopsis_h2
        node = synopsis_h2.next

        while node

          if node.name.eql? 'h2'
            node = nil
            next
          end

          # Replace occurrences of br with escaped newlines.
          if node.to_s.eql? '<br>' or node.to_s.eql? '<br />'
            synopsis << "\\n"
          else
            synopsis << '' << Nokogiri::HTML(node.to_s).xpath('//text()').map(&:text).join('')
          end

          node = node.next

        end
      end

      synopsis
    end


    def parse_rank(nokogiri)
      nokogiri.at('div[@id="contentWrapper"] > div > span').text.gsub(/\D/, '').to_i
    end


    def parse_image_url(nokogiri)
      if image_node = nokogiri.at('div#content tr td div img')
        image_node['src']
      end
    end


    def parse_alternative_titles(nokogiri)
      other_titles = {}

      if (node = nokogiri.at('//span[text()="English:"]')) && node.next
        other_titles[:english] = node.next.text.strip.split(/,\s?/)
      end
      if (node = nokogiri.at('//span[text()="Synonyms:"]')) && node.next
        other_titles[:synonyms] = node.next.text.strip.split(/,\s?/)
      end
      if (node = nokogiri.at('//span[text()="Japanese:"]')) && node.next
        other_titles[:japanese] = node.next.text.strip.split(/,\s?/)
      end

      other_titles
    end

    def parse_type(nokogiri)
      if (node = nokogiri.at('//span[text()="Type:"]')) && node.next.next
        type = node.next.next.text.strip

        type
      end
    end

    def parse_episode_count(nokogiri)
      if (node = nokogiri.at('//span[text()="Episodes:"]')) && node.next
        episodes = node.next.text.strip.gsub(',', '').to_i
        episodes = nil if episodes == 0

        episodes
      end
    end

    def parse_status(nokogiri)
      if (node = nokogiri.at('//span[text()="Status:"]')) && node.next
        status = node.next.text.strip

        status
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

    def parse_genres(nokogiri)
      genres = []

      if node = nokogiri.at('//span[text()="Genres:"]')
        node.parent.search('a').each do |a|
          genres << a.text.strip
        end

        genres
      end
    end

    def parse_rating(nokogiri)
      if (node = nokogiri.at('//span[text()="Rating:"]')) && node.next
        classification = node.next.text.strip

        classification
      end
    end

    def parse_score(nokogiri)
      if (node = nokogiri.at('//span[@itemprop="ratingValue"]'))
        members_score = node.text.strip.to_f

        members_score
      end
    end

    def parse_popularity_rank(nokogiri)
      if (node = nokogiri.at('//span[text()="Popularity:"]')) && node.next
        popularity_rank = node.next.text.strip.sub('#', '').gsub(',', '').to_i

        popularity_rank
      end
    end

    def parse_member_count(nokogiri)
      if (node = nokogiri.at('//span[text()="Members:"]')) && node.next
        member_count = node.next.text.strip.gsub(',', '').to_i

        member_count
      end
    end

    def parse_favorite_count(nokogiri)
      if (node = nokogiri.at('//span[text()="Favorites:"]')) && node.next
        favorite_count = node.next.text.strip.gsub(',', '').to_i

        favorite_count
      end
    end

    def parse_tags(nokogiri)
      tags = []

      if (node = nokogiri.at('//span[preceding-sibling::h2[text()="Popular Tags"]]'))
        node.search('a').each do |a|
          tags << a.text
        end
      end

      tags
    end

    def parse_additional_info_urls(nokogiri)
      additional_info_urls = {}

      if (node = nokogiri.at('//div[@id="horiznav_nav"]/ul'))
        urls = node.search('li')

        (0..urls.length-1).each { |i|
          url_node = urls[i]

          additional_url_title = url_node.at('//div[@id="horiznav_nav"]/ul/li['+(i+1).to_s+']/a[1]/text()')
          additional_url = url_node.at('//div[@id="horiznav_nav"]/ul/li['+(i+1).to_s+']/a[1]/@href')

          if (additional_url_title.to_s == 'Details')
            additional_info_urls[:details] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Reviews')
            additional_info_urls[:reviews] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Recommendations')
            additional_info_urls[:recommendations] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Stats')
            additional_info_urls[:stats] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Characters &amp; Staff')
            additional_info_urls[:characters_and_staff] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'News')
            additional_info_urls[:news] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Forum')
            additional_info_urls[:forum] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Pictures')
            additional_info_urls[:pictures] = additional_url.to_s
          end
        }
      end

      additional_info_urls
    end

    def parse_manga_adaptations(html_string)
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
      manga = []
      if html_string.match(string_to_match)
        $1.scan(regex_pattern) do |url, anime_id, title|
          manga << {
              :anime_id => anime_id,
              :title => title,
              :url => url
          }
        end
      end

      manga
    end

  end

end