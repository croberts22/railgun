require File.dirname(__FILE__) + '/test_helper'

class TestAnimeScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/anime_response.html"))
  end


  ### Tests

  def test_parse_id
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_id(nokogiri)
    expected = 25835

    assert_equal(expected, actual)
  end

  def test_parse_title
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_title(nokogiri)
    expected = 'Shirobako'

    assert_equal(expected, actual)
  end

  def test_parse_synopsis
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_synopsis(nokogiri)
    expected = "Aoi will never forget how she felt the day her high school animation club's labor of love was shown at the cultural festival. The sense of awe and the feeling of accomplishment that came with completing their very first project are exactly what encouraged Aoi and her club mates to enter the animation industry in the first place. But two years later Aoi has graduated, and now that she works as a production assistant for a big-name animation studio, the daunting reality of her job has somewhat diminished her enthusiasm. Despite the long hours and the punishing schedule, Aoi still hopes to fulfill the promise she and her club friends Ema, Shizuka, Misa, and Midori made: to one day reunite and make a real animated feature of their own as professionals!

(Source: Sentai Filmworks)"

    assert(!(actual.include? '<br>'))
    assert(!(actual.include? '<br />'))
    assert_equal(expected, actual)
  end

  def test_parse_rank
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_rank(nokogiri)
    expected = 101

    assert_equal(expected, actual)
  end

  def test_parse_image_url
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_image_url(nokogiri)
    expected = 'http://cdn.myanimelist.net/images/anime/6/68021.jpg'

    assert_equal(expected, actual)
  end

  def test_parse_alternative_titles
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_alternative_titles(nokogiri)
    expected = {
        english: ['Shirobako'],
        japanese: ['SHIROBAKO']
    }

    assert_equal(expected, actual)
  end


  def test_parse_type
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_type(node)
    expected = 'TV'

    assert_equal(expected, actual)
  end

  def test_parse_episode_count
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_episode_count(node)
    expected = 24

    assert_equal(expected, actual)
  end

  def test_parse_airing_start_date
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_airing_start_date(node)
    expected = Time.parse('Oct 9, 2014')

    assert_equal(expected, actual)
  end

  def test_parse_airing_end_date
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_airing_end_date(node)
    expected = Time.parse('Mar 26, 2015')

    assert_equal(expected, actual)
  end

  def test_parse_genres
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_genres(node)
    expected = %w[ Comedy Drama ]

    assert_equal(expected, actual)
  end

  def test_parse_rating
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_rating(node)
    expected = 'PG-13 - Teens 13 or older'

    assert_equal(expected, actual)
  end

  def test_parse_anime
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    anime = Railgun::Anime.new
    scraper.parse_anime(nokogiri, anime)

    assert(!anime.id.nil?)
    assert(!anime.title.nil?)
    assert(!anime.synopsis.nil?)
    assert(!anime.rank.nil?)
    assert(!anime.image_url.nil?)
    assert(!anime.other_titles.empty?)
    assert(!anime.type.nil?)
    assert(anime.episodes > 0)
    assert(!anime.start_date.nil?)
    assert(!anime.end_date.nil?)
    assert(!anime.genres.empty?)
    assert(!anime.classification.nil?)

  end

end