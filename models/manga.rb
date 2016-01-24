require_relative 'resource'
require_relative '../utilities/anime_scraper'

module Railgun

  class Manga < Resource

    attr_accessor :rank, :popularity_rank, :volumes, :chapters,
                  :members_score, :members_count, :favorited_count, :synopsis
    attr_accessor :listed_manga_id
    attr_reader :type, :status
    attr_writer :genres, :tags, :other_titles, :anime_adaptations, :related_manga, :alternative_versions,
                :prequels, :sequels, :side_stories, :spin_offs, :summaries, :alternative_settings, :full_stories, :others

  end

  ### Custom Setter Methods

  def status=(value)
    @status = case value
                when '2', 2, /finished/i
                  :finished
                when '1', 1, /publishing/i
                  :publishing
                when '3', 3, /not yet published/i
                  :"not yet published"
                else
                  :finished
              end
  end

  def type=(value)
    @type = case value
              when /manga/i, '1', 1
                :Manga
              when /novel/i, '2', 2
                :Novel
              when /one shot/i, '3', 3
                :"One Shot"
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

  def spin_offs
    @spin_offs ||= []
  end

  def summaries
    @summaries ||= []
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
        :rank => rank,
        :image_url => image_url,
        :type => type,
        :status => status,
        :volumes => volumes,
        :chapters => chapters,
        :genres => genres,
        :members_score => members_score,
        :members_count => members_count,
        :popularity_rank => popularity_rank,
        :favorited_count => favorited_count,
        :tags => tags,
        :synopsis => synopsis,
        :anime_adaptations => anime_adaptations,
        :related_manga => related_manga,
        :alternative_versions => alternative_versions,
        :read_status => read_status,
        :listed_manga_id => listed_manga_id,
        :chapters_read => chapters_read,
        :volumes_read => volumes_read,
        :score => score,
        :side_stories => side_stories,
        :prequels => prequels,
        :sequels => sequels,
        :spin_offs => spin_offs,
        :summaries => summaries,
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

    puts 'Scraping manga...'

    manga = Manga.new
    nokogiri = MALNetworkService.nokogiri_from_request("http://myanimelist.net/manga/#{id}")

    scraper = MangaScraper.new
    scraper.parse_manga(nokogiri, manga)

    # TODO:
    # If any options were passed in, perform a fetch and continue parsing.

    manga
  end

end