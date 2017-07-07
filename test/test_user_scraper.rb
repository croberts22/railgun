require File.dirname(__FILE__) + '/test_helper'

class TestUserListScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    # Shirobako
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/friends_response.html"))
  end

  def nodes_from_nokogiri(nokogiri)
    nodes = nokogiri.at('//div[@class="majorPad"]').children.select do |div|
      div['class'] == 'friendHolder'
    end

    nodes
  end

  ### Tests

  def test_parse_id
    scraper = Railgun::UserListScraper.new
    nokogiri = nokogiri_for_sample_response
    nodes = nodes_from_nokogiri(nokogiri)

    actual = scraper.parse_id(nodes.first)
    expected = 'redoctober21'

    assert_equal(expected, actual)
  end

  def test_parse_name
    scraper = Railgun::UserListScraper.new
    nokogiri = nokogiri_for_sample_response
    nodes = nodes_from_nokogiri(nokogiri)

    actual = scraper.parse_name(nodes.first)
    expected = 'redoctober21'

    assert_equal(expected, actual)
  end

  def test_parse_image_url
    scraper = Railgun::UserListScraper.new
    nokogiri = nokogiri_for_sample_response
    nodes = nodes_from_nokogiri(nokogiri)

    actual = scraper.parse_image_url(nodes.first)
    expected = 'https://myanimelist.cdn-dena.com/images/questionmark_50.gif'

    assert_equal(expected, actual)
  end

  def test_parse
    scraper = Railgun::UserListScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.scrape(nokogiri)

    actual.each { |user|

      id = user[:id]
      assert_not_nil(id)
      assert(id.is_a? String)

      name = user[:name]
      assert_not_nil(name)
      assert(name.is_a? String)

      image_url = user[:image_url]
      assert_not_nil(image_url)
      assert(image_url.is_a? String)

    }



  end

end