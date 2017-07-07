require File.dirname(__FILE__) + '/test_helper'

class TestPerson < Test::Unit::TestCase

  ### Convenience Methods

  def nokogiri_for_sample_response
    # Kana Hanazawa
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/person_185.html"))
  end

  def nokogiri_for_sample_response_alternate_names
    # Haruka Tomatsu
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/person_890.html"))
  end

  def test_parse_id
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_id(nokogiri)
    expected = '185'

    assert_equal(expected, actual)
  end

  def test_parse_name
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_name(nokogiri)
    expected = 'Hanazawa, Kana'

    assert_equal(expected, actual)
  end

  def test_parse_url
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_url(nokogiri)
    expected = 'https://myanimelist.net/people/185/Kana_Hanazawa'

    assert_equal(expected, actual)
  end

  def test_parse_given_name
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_given_name(nokogiri)
    expected = '香菜'

    assert_equal(expected, actual)
  end

  def test_parse_family_name
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_family_name(nokogiri)
    expected = '花澤'

    assert_equal(expected, actual)
  end

  def test_parse_alternate_names
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response_alternate_names

    actual = scraper.parse_alternate_names(nokogiri)
    expected = %w(Sphere スフィア)

    assert_equal(expected, actual)
  end

  def test_parse_birthday
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_birthday(nokogiri)
    expected = Time.parse('Feb 25, 1989').utc.iso8601

    assert_equal(expected, actual)
  end

  def test_parse_website
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_website(nokogiri)
    expected = 'http://www.hanazawakana-music.net/'

    assert_equal(expected, actual)
  end

  def test_parse_favorite_count
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_favorite_count(nokogiri)
    expected = 41885

    assert_equal(expected, actual)
  end

  def test_parse_more_info
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_more_info(nokogiri)
    expected = 'Kana Hanazawa used to be a junior idol in Akiba where hundreds of people came to watch her, which is how she got her breakthrough for her acting career in commercials before becoming a voice actor.'

    assert(actual.include? expected)
  end

  def test_parse_voice_acting_roles
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_voice_acting_roles(nokogiri)

    actual.each do |role|

      anime = role[:anime]

      assert_not_nil(anime)
      assert(anime.is_a? Hash)

      assert_not_nil(anime[:id])
      assert(anime[:id].is_a? String)

      assert_not_nil(anime[:name])
      assert(anime[:name].is_a? String)

      assert_not_nil(anime[:url])
      assert(anime[:url].is_a? String)

      assert_not_nil(anime[:image_url])
      assert(anime[:image_url].is_a? String)

      character = role[:character]

      assert_not_nil(character)
      assert(character.is_a? Hash)

      assert_not_nil(character[:id])
      assert(character[:id].is_a? String)

      assert_not_nil(character[:name])
      assert(character[:name].is_a? String)

      assert_not_nil(character[:url])
      assert(character[:url].is_a? String)

      assert_not_nil(character[:image_url])
      assert(character[:image_url].is_a? String)

      assert_not_nil(character[:role])
      assert(character[:role].is_a? String)

    end

  end

  def test_anime_staff_positions
    # TODO
  end

  def test_parse_published_manga
    # TODO
  end

  def test_scrape
    scraper = Railgun::PersonScraper.new
    nokogiri = nokogiri_for_sample_response

    person = Railgun::Person.new
    scraper.scrape(nokogiri, person)

    assert_not_nil(person.id)
    assert(person.id.is_a? String)

    assert_not_nil(person.name)
    assert(person.name.is_a? String)

    assert_not_nil(person.url)
    assert(person.url.is_a? String)

    assert_not_nil(person.image_url)
    assert(person.image_url.is_a? String)

    assert_not_nil(person.given_name)
    assert(person.given_name.is_a? String)

    assert_not_nil(person.family_name)
    assert(person.family_name.is_a? String)

    assert_not_nil(person.birthday)
    assert(person.birthday.is_a? String)

    assert_not_nil(person.website)
    assert(person.website.is_a? String)

    assert_not_nil(person.favorited_count)
    assert(person.favorited_count.is_a? Integer)

    assert_not_nil(person.more_info)
    assert(person.more_info.is_a? String)

    assert_not_nil(person.voice_acting_roles)
    assert(person.voice_acting_roles.is_a? Array)


      #assert_not_nil(person.anime_staff_positions)
      #assert_not_nil(person.published_manga)
  end

end