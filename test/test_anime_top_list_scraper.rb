require File.dirname(__FILE__) + '/test_helper'

class TestAnimeTopListScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/top_anime_response.html"))
  end

  def nokogiri_for_popular_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/popular_anime_response.html"))
  end

  ### Tests

  def test_scrape
    nokogiri = nokogiri_for_sample_response
    scraper = Railgun::AnimeListScraper.new

    result = scraper.scrape(nokogiri, 'all')

    assert(!result.empty?)

    assert(result)

    result.each { |row|

      id = row[:id]

      assert(!id.nil?)
      assert(id.is_a? String)
      assert(!id.empty?)

      name = row[:name]

      assert(!name.nil?)
      assert(name.is_a? String)
      assert(!name.empty?)

      url = row[:url]

      assert(!url.nil?)
      assert(url.is_a? String)
      assert(!url.empty?)
      assert(url.include? id)

      image_url = row[:image_url]

      assert(!image_url.nil?)
      assert(image_url.is_a? String)
      assert(!image_url.empty?)

      type = row[:type]

      assert(!type.nil?)
      assert(type.is_a? String)
      assert(!type.empty?)

      episodes = row[:episodes]

      assert(!episodes.nil?)
      assert(episodes.is_a? Integer)
      assert(episodes >= 0)

      start_date = row[:start_date]

      assert(!start_date.nil?)
      assert(start_date.is_a? String)

      end_date = row[:end_date]

      assert(!end_date.nil?)
      assert(end_date.is_a? String)

      stats = row[:stats]

      assert(!stats.nil?)

      score = stats[:score]

      assert(!score.nil?)
      assert(score.is_a? Float)
      assert(score >= 0.00)

      rank = stats['rank']

      assert(!rank.nil?)
      assert(rank.is_a? Integer)
      assert(rank >= 0)
      
      member_count = stats[:member_count]

      assert(!member_count.nil?)
      assert(member_count.is_a? Integer)
      assert(member_count >= 0)

    }

  end

  def test_scrape_popular
    nokogiri = nokogiri_for_popular_response
    scraper = Railgun::AnimeListScraper.new

    result = scraper.scrape(nokogiri, 'popular')

    assert(!result.empty?)

    assert(result)

    result.each { |row|

      id = row[:id]

      assert(!id.nil?)
      assert(id.is_a? String)
      assert(!id.empty?)

      name = row[:name]

      assert(!name.nil?)
      assert(name.is_a? String)
      assert(!name.empty?)

      url = row[:url]

      assert(!url.nil?)
      assert(url.is_a? String)
      assert(!url.empty?)
      assert(url.include? id)

      image_url = row[:image_url]

      assert(!image_url.nil?)
      assert(image_url.is_a? String)
      assert(!image_url.empty?)

      type = row[:type]

      assert(!type.nil?)
      assert(type.is_a? String)
      assert(!type.empty?)

      episodes = row[:episodes]

      assert(!episodes.nil?)
      assert(episodes.is_a? Integer)
      assert(episodes >= 0)

      start_date = row[:start_date]

      assert(!start_date.nil?)
      assert(start_date.is_a? String)

      end_date = row[:end_date]

      assert(!end_date.nil?)
      assert(end_date.is_a? String)

      stats = row[:stats]

      assert(!stats.nil?)

      score = stats[:score]

      assert(!score.nil?)
      assert(score.is_a? Float)
      assert(score >= 0.00)

      rank = stats['popularity_rank']

      assert(!rank.nil?)
      assert(rank.is_a? Integer)
      assert(rank >= 0)

      member_count = stats[:member_count]

      assert(!member_count.nil?)
      assert(member_count.is_a? Integer)
      assert(member_count >= 0)

    }

  end

  def test_rank_name
    scraper = Railgun::AnimeListScraper.new

    list_type = 'all'
    actual = scraper.rank_key(list_type)
    expected = 'rank'
    assert(expected, actual)

    list_type = 'airing'
    actual = scraper.rank_key(list_type)
    expected = 'airing_rank'
    assert(expected, actual)

    list_type = 'upcoming'
    actual = scraper.rank_key(list_type)
    expected = 'upcoming_rank'
    assert(expected, actual)

    list_type = 'tv'
    actual = scraper.rank_key(list_type)
    expected = 'tv_rank'
    assert(expected, actual)

    list_type = 'movie'
    actual = scraper.rank_key(list_type)
    expected = 'movie_rank'
    assert(expected, actual)

    list_type = 'ova'
    actual = scraper.rank_key(list_type)
    expected = 'ova_rank'
    assert(expected, actual)

    list_type = 'special'
    actual = scraper.rank_key(list_type)
    expected = 'special_rank'
    assert(expected, actual)

    list_type = 'popular'
    actual = scraper.rank_key(list_type)
    expected = 'popularity_rank'
    assert(expected, actual)

    list_type = 'favorite'
    actual = scraper.rank_key(list_type)
    expected = 'favorited_rank'
    assert(expected, actual)

    list_type = 'thisdoesnotexist'
    actual = scraper.rank_key(list_type)
    expected = 'rank'
    assert(expected, actual)

  end


end