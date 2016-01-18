require 'nokogiri'

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

  class AnimeScraper

    def parse_anime(nokogiri, anime)

      anime.id = parse_id(nokogiri)
      anime.title = parse_title(nokogiri)
      anime.synopsis = parse_synopsis(nokogiri)

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

  end

end