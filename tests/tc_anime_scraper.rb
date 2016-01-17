require 'test/unit'
require_relative '../railgun'

class TestAnimeScraper < Test::Unit::TestCase

  def test_parse_anime
    scraper = Railgun::AnimeScraper.new

    #File.join(File.dirname(__FILE__), '../../') # add proper number of ..
    nokogiri = Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/anime_response.html"))

    title = scraper.parse_title(nokogiri)
    expected = 'Shirobako'

    assert_equal(expected, title)

  end

  def test_parse_synopsis

  end


end