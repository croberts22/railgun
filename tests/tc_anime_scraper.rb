require 'test/unit'
require_relative '../railgun'

class TestAnimeScraper < Test::Unit::TestCase

  def nokogiri_for_sample_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/anime_response.html"))
  end

  def test_parse_anime
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    title = scraper.parse_title(nokogiri)
    expected = 'Shirobako'

    assert_equal(expected, title)
  end

  def test_parse_synopsis
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    title = scraper.parse_synopsis(nokogiri)
    expected = "Aoi will never forget how she felt the day her high school animation club's labor of love was shown at the cultural festival. The sense of awe and the feeling of accomplishment that came with completing their very first project are exactly what encouraged Aoi and her club mates to enter the animation industry in the first place. But two years later Aoi has graduated, and now that she works as a production assistant for a big-name animation studio, the daunting reality of her job has somewhat diminished her enthusiasm. Despite the long hours and the punishing schedule, Aoi still hopes to fulfill the promise she and her club friends Ema, Shizuka, Misa, and Midori made: to one day reunite and make a real animated feature of their own as professionals!

(Source: Sentai Filmworks)"

    assert(!(title.include? '<br>'))
    assert(!(title.include? '<br />'))
    assert_equal(expected, title)

  end


end