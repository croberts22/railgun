require 'nokogiri'
require_relative '../utilities/base_scraper'

module Railgun

  class Anime

    attr_accessor :id, :title, :rank, :popularity_rank, :image_url, :episodes, :classification,
                  :members_score, :members_count, :favorited_count, :synopsis, :start_date, :end_date
    attr_accessor :listed_anime_id, :parent_story
    attr_reader :type, :status
    attr_writer :genres, :tags, :other_titles, :manga_adaptations, :prequels, :sequels, :side_stories,
                :character_anime, :spin_offs, :summaries, :alternative_versions, :summary_stats, :score_stats,
                :additional_info_urls, :character_voice_actors, :alternative_settings, :full_stories, :others


    ### Custom Setter Methods

    def type=(value)
      @type = case value
                when /TV/i, '1', 1
                  :TV
                when /OVA/i, '2', 2
                  :OVA
                when /Movie/i, '3', 3
                  :Movie
                when /Special/i, '4', 4
                  :Special
                when /ONA/i, '5', 5
                  :ONA
                when /Music/i, '6', 6
                  :Music
                else
                  :TV
              end
    end

    def status=(value)
      @status = case value
                  when '2', 2, /finished airing/i
                    :'finished airing'
                  when '1', 1, /currently airing/i
                    :'currently airing'
                  when '3', 3, /not yet aired/i
                    :'not yet aired'
                  else
                    :'finished airing'
                end
    end

    def other_titles
      @other_titles ||= {}
    end

    def summary_stats
      @summary_stats ||= {}
    end

    def score_stats
      @score_stats ||= {}
    end

    def genres
      @genres ||= []
    end

    def tags
      @tags ||= []
    end

    def manga_adaptations
      @manga_adaptations ||= []
    end

    def prequels
      @prequels ||= []
    end

    def sequels
      @sequels ||= []
    end

    def side_stories
      @side_stories ||= []
    end

    def character_anime
      @character_anime ||= []
    end

    def spin_offs
      @spin_offs ||= []
    end

    def summaries
      @summaries ||= []
    end

    def alternative_versions
      @alternative_versions ||= []
    end

    def additional_info_urls
      @additional_info_urls ||= {}
    end

    def character_voice_actors
      @character_voice_actors ||= []
    end

    def alternative_settings
      @alternative_settings ||= []
    end

    def full_stories
      @full_stories ||= []
    end

    def others
      @others ||= []
    end

    def synopsis
      @synopsis ||= ''
    end

    def attributes
      {
          :id => id,
          :title => title,
          :other_titles => other_titles,
          :summary_stats => summary_stats,
          :score_stats => score_stats,
          :additional_info_urls => additional_info_urls,
          :synopsis => synopsis,
          :type => type,
          :rank => rank,
          :popularity_rank => popularity_rank,
          :image_url => image_url,
          :episodes => episodes,
          :status => status,
          :start_date => start_date,
          :end_date => end_date,
          :genres => genres,
          :tags => tags,
          :classification => classification,
          :members_score => members_score,
          :members_count => members_count,
          :favorited_count => favorited_count,
          :manga_adaptations => manga_adaptations,
          :prequels => prequels,
          :sequels => sequels,
          :side_stories => side_stories,
          :parent_story => parent_story,
          :character_anime => character_anime,
          :spin_offs => spin_offs,
          :summaries => summaries,
          :alternative_versions => alternative_versions,
          :listed_anime_id => listed_anime_id,
          :character_voice_actors => character_voice_actors,
          :alternative_settings => alternative_settings,
          :full_stories => full_stories,
          :others => others
      }
    end

    def to_json(*args)
      attributes.to_json(*args)
    end


    ### Creation Methods

    def self.scrape(id, options)

      puts 'Scraping anime...'

      anime = Anime.new
      nokogiri = MALNetworkService.nokogiri_from_request("http://myanimelist.net/anime/#{id}")

      scraper = AnimeScraper.new
      scraper.parse_anime(nokogiri, anime)

      anime
    end


  end


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
      anime.start_date = parse_airing_end_date(node)
      anime.end_date = parse_airing_end_date(node)
      anime.genres = parse_genres(node)
      anime.classification = parse_rating(node)
      anime.members_score = parse_score(node)
      anime.popularity_rank = parse_popularity_rank(node)
      anime.members_count = parse_member_count(node)
      anime.favorited_count = parse_favorite_count(node)

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
      if node = nokogiri.at('//span[text()="Genres:"]')
        genres = []
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

  end

end