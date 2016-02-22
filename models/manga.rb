require_relative 'resource'
require_relative '../utilities/manga_scraper'
require_relative '../utilities/manga_search_scraper'

module Railgun

  class Manga < Resource

    attr_accessor :rank, :popularity_rank, :volumes, :chapters,
                  :members_score, :members_count, :favorited_count, :synopsis, :start_date, :end_date
    attr_reader :type, :status
    attr_writer :genres, :tags,
                :other_titles, :anime_adaptations, :prequels, :sequels, :side_stories,
                :spin_offs, :summaries, :related_manga, :alternative_versions, :alternative_settings,
                :full_stories, :others, :parent_story,
                :summary_stats, :score_stats,  :additional_info_urls, :character_voice_actors


    ### Custom Setter Methods

    def status=(value)
      @status = case value
                  when '2', 2, /finished/i
                    :'finished'
                  when '1', 1, /publishing/i
                    :'publishing'
                  when '3', 3, /not yet published/i
                    :'not yet published'
                  else
                    :'finished'
                end
    end

    def type=(value)
      @type = case value
                when /manga/i, '1', 1
                  :Manga
                when /novel/i, '2', 2
                  :Novel
                when /one shot/i, '3', 3
                  :'One Shot'
                when /doujin/i, '4', 4
                  :Doujin
                when /manwha/i, '5', 5
                  :Manwha
                when /manhua/i, '6', 6
                  :Manhua
                when /OEL/i, '7', 7 # "OEL manga = Original English-language manga"
                  :OEL
                else
                  :Manga
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

    def anime_adaptations
      @anime_adaptations ||= []
    end

    def related_manga
      @related_manga ||= []
    end

    def alternative_versions
      @alternative_versions ||= []
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

    def parent_story
      @parent_story ||= {}
    end

    def spin_offs
      @spin_offs ||= []
    end

    def summaries
      @summaries ||= []
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
          id: id,
          title: title,
          type: type,
          volumes: volumes,
          chapters: chapters,

          genres: genres,

          synopsis: synopsis,
          status: status,
          start_date: start_date,
          end_date: end_date,
          image_url: image_url,
          other_titles: other_titles,
          tags: tags,

          stats: {
              rank: rank,
              popularity_rank: popularity_rank,
              members_score: members_score,
              members_count: members_count,
              favorited_count: favorited_count,
              summary_stats: summary_stats,
              score_stats: score_stats
          },

          related_manga: {
              anime_adaptations: anime_adaptations,
              prequels: prequels,
              sequels: sequels,
              side_stories: side_stories,
              parent_story: parent_story,
              spin_offs: spin_offs,
              summaries: summaries,
              alternative_settings: alternative_settings,
              alternative_versions: alternative_versions,
              full_stories: full_stories,
              others: others
          },

          characters: character_voice_actors,
          additional_info_urls: additional_info_urls
      }
    end

    def to_json(*args)
      attributes.to_json(*args)
    end


    ### Creation Methods

    def self.scrape(id, options)

      puts 'Scraping manga...'

      manga = Manga.new
      nokogiri = MALNetworkService.nokogiri_from_request("http://myanimelist.net/manga/#{id}")

      scraper = MangaScraper.new
      scraper.parse_manga(nokogiri, manga)

      # TODO:
      # If any options were passed in, perform a fetch and continue parsing.

      manga
    end

    def self.search(query)
      redirectable_nokogiri = MALNetworkService.nokogiri_from_redirectable_request(MALNetworkService.manga_search_request_with_query(query))

      # Did we redirect? If so, we know this is just one manga object, and we can parse it as an manga.
      # Otherwise, parse the table.
      if redirectable_nokogiri.redirected then
        manga = Manga.new
        scraper = MangaScraper.new
        scraper.parse_manga(redirectable_nokogiri.nokogiri, manga)

        manga
      else
        scraper = MangaSearchScraper.new
        manga = scraper.scrape(redirectable_nokogiri.nokogiri)

        manga
      end
    end

  end
end