require File.dirname(__FILE__) + '/test_helper'

class TestAnimeSeasonalScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    # Spring 2017
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/seasonal_anime.html"))
  end

  def test_parse_seasonal_anime
    scraper = Railgun::AnimeSeasonalScraper.new
    nokogiri = nokogiri_for_sample_response

    result = scraper.scrape(nokogiri)

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

    }


  end

end