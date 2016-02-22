require File.dirname(__FILE__) + '/test_helper'

class TestMangaSearchScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/railgun_search_manga_response.html"))
  end


  ### Tests

  def test_scrape
    nokogiri = nokogiri_for_sample_response
    scraper = Railgun::MangaSearchScraper.new

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

      type = row[:type]

      assert(!type.nil?)
      assert(type.is_a? String)
      assert(!type.empty?)

      volumes = row[:volumes]

      assert(!volumes.nil?)
      assert(volumes.is_a? Integer)
      assert(volumes >= 0)

      synopsis = row[:synopsis]

      assert(!synopsis.nil?)
      assert(synopsis.is_a? String)
      assert(!synopsis.empty?)
      assert(!(synopsis.include? 'read more.'))

    }

  end


end