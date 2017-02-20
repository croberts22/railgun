require File.dirname(__FILE__) + '/test_helper'

class TestAnimeSearchScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/railgun_search_anime_response.html"))
  end


  ### Tests

  def test_scrape
    nokogiri = nokogiri_for_sample_response
    scraper = Railgun::AnimeSearchScraper.new

    result = scraper.scrape(nokogiri)

    assert(!result.empty?)

    result.each { |row|

      id = row[:id]

      assert(!id.nil?)
      assert(id.is_a? String)
      assert(!id.empty?)

      title = row[:title]

      assert(!title.nil?)
      assert(title.is_a? String)
      assert(!title.empty?)

      url = row[:url]

      assert(!url.nil?)
      assert(url.is_a? String)
      assert(!url.empty?)
      assert(url.include? id)

      image_url = row[:image_url]

      assert(!image_url.nil?)
      assert(image_url.is_a? String)
      assert(!image_url.empty?)
      assert_not_equal('http://cdn.myanimelist.net/images/spacer.gif', image_url)

      type = row[:type]

      assert(!type.nil?)
      assert(type.is_a? String)
      assert(!type.empty?)

      episodes = row[:episodes]

      assert(!episodes.nil?)
      assert(episodes.is_a? Integer)
      assert(episodes >= 0)

      synopsis = row[:synopsis]

      assert(!synopsis.nil?)
      assert(synopsis.is_a? String)
      assert(!synopsis.empty?)
      assert(!(synopsis.include? 'read more.'))

    }

  end


end