require 'test/unit'
require '../railgun'

class AnimeScraperTests < Test::Unit::TestCase

  def test_parse_anime
    scraper = Railgun::AnimeScraper.new

    nokogiri = Nokogiri::HTML(File.read('./html/anime_response.html'))

    title = scraper.parse_title(nokogiri)
    expected = 'Shirobako'

    assert_equal(expected, title)

  end

  def test_parse_synopsis

  end


end