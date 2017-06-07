require File.dirname(__FILE__) + '/test_helper'

class TestUserScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    # Shirobako
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/anime_25835.html"))
  end

  ### Tests

  def test_parse_id
    scraper = Railgun::UserScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_id(nokogiri)
    expected = '25835'

    assert_equal(expected, actual)
  end

  def test_parse_name
    scraper = Railgun::UserScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_name(nokogiri)
    expected = 'Shirobako'

    assert_equal(expected, actual)
  end

  def test_parse_image_url
    scraper = Railgun::UserScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_image_url(nokogiri)
    expected = 'https://myanimelist.cdn-dena.com/images/anime/6/68021.jpg'

    assert_equal(expected, actual)
  end

end