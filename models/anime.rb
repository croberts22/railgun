require_relative 'resource'
require_relative '../utilities/anime_scraper'
require_relative '../utilities/search_scraper'

module Railgun

  class Anime < Resource

    attr_accessor :rank, :popularity_rank, :episodes, :classification,
                  :members_score, :members_count, :favorited_count, :synopsis, :start_date, :end_date
    attr_reader :type, :status
    attr_writer :genres, :tags,
                :other_titles, :manga_adaptations, :prequels, :sequels, :side_stories,
                :character_anime, :spin_offs, :summaries, :alternative_versions, :alternative_settings,
                :full_stories, :others, :parent_story,
                :summary_stats, :score_stats,  :additional_info_urls, :character_voice_actors


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

    def parent_story
      @parent_story ||= {}
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
          id: id,
          title: title,
          type: type,
          episodes: episodes,

          classification: classification,
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

          related_anime: {
              manga_adaptations: manga_adaptations,
              prequels: prequels,
              sequels: sequels,
              side_stories: side_stories,
              parent_story: parent_story,
              character_anime: character_anime,
              spin_offs: spin_offs,
              summaries: summaries,
              alternative_versions: alternative_versions,
              alternative_settings: alternative_settings,
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

      puts 'Scraping anime...'

      anime = Anime.new
      nokogiri = MALNetworkService.nokogiri_from_request(MALNetworkService.anime_request_for_id(id))

      scraper = AnimeScraper.new
      scraper.parse_anime(nokogiri, anime)

      # If any options were passed in, perform a fetch and continue parsing.
      if options.include? 'characters_and_staff'
        puts 'Scraping characters and staff...'
        nokogiri = MALNetworkService.nokogiri_from_request(anime.additional_info_urls[:characters_and_staff])
        characters_and_staff = scraper.parse_staff(nokogiri)
        anime.character_voice_actors = characters_and_staff
      end

      if options.include? 'stats'
        puts 'Scraping additional stats...'
        nokogiri = MALNetworkService.nokogiri_from_request(anime.additional_info_urls[:stats])
        anime.summary_stats = scraper.parse_summary_stats(nokogiri)
        anime.score_stats = scraper.parse_score_stats(nokogiri)
      end

      anime
    end

    def self.search(query)
      redirectable_nokogiri = MALNetworkService.nokogiri_from_redirectable_request(MALNetworkService.anime_search_request_with_query(query))

      # Did we redirect? If so, we know this is just one anime object, and we can parse it as an anime.
      # Otherwise, parse the table.
      if redirectable_nokogiri.redirected then
        anime = Anime.new
        scraper = AnimeScraper.new
        scraper.parse_anime(redirectable_nokogiri.nokogiri, anime)

        anime
      else
        scraper = SearchScraper.new
        anime = scraper.scrape(redirectable_nokogiri.nokogiri)

        anime
      end
    end
  end

end