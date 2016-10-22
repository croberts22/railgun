require File.dirname(__FILE__) + '/test_helper'

class TestAnimeTopListScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/top_anime_response.html"))
  end


  ### Tests

  def test_scrape
    nokogiri = nokogiri_for_sample_response
    scraper = Railgun::AnimeListScraper.new

    result = scraper.scrape(nokogiri)

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

      member_count = row[:member_count]

      assert(!member_count.nil?)
      assert(member_count.is_a? Integer)
      assert(member_count >= 0)

    }

  end


end