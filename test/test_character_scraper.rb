require File.dirname(__FILE__) + '/test_helper'

class TestCharacterScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    # Izuku Midoriya
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/character_117909.html"))
  end


  ### Tests

  def test_parse_id
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_id(nokogiri)
    expected = '117909'

    assert_equal(expected, actual)
  end

  def test_parse_name
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_name(nokogiri)
    expected = 'Izuku Midoriya'

    assert_equal(expected, actual)
  end

  def test_parse_url
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_url(nokogiri)
    expected = 'https://myanimelist.net/character/117909/Izuku_Midoriya'

    assert_equal(expected, actual)
  end

  def test_parse_image_url
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_image_url(nokogiri)
    expected = 'https://myanimelist.cdn-dena.com/images/characters/7/299404.jpg'

    assert_equal(expected, actual)
  end

  def test_parse_nickname
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_nickname(nokogiri)
    expected = 'Deku'

    assert_equal(expected, actual)
  end


  def test_parse_biography
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_biography(nokogiri)
    expected = "Age: 14-16
Birthday: July 15
Blood Type: O
Height: 166 cm (5'5\")
Affiliation: Yuuei
Quirk: One For All

He is the main protagonist of Boku no Hero Academia. Though originally born without a Quirk, he manages to catch the attention of the legendary hero All Might and has since become his close pupil and a student at UA.

Izuku is a very timid and polite boy. Due to being bullied since childhood for being born without a Quirk, he is initially portrayed as insecure, being more reserved and not self expressive, especially in front of Katsuki. However, after being accepted into Yuuei and facing Katsuki during Battle Training, he has gradually become more confident and brave.

Izuku is also very diligent and strong willed. Since he greatly admires Heroes and has always aimed to be one, he has a habit of writing down in his notebooks all he knows about heroes and their quirks, including other Yuuei students. He is a very caring person, and will never hesitate to rescue someone in danger, even if he knows he's not strong enough. When someone has a personal problem, Izuku will always try to help, even if it's not his business. Izuku also has the tendency to overthink with anything that grabs his attention, which makes him start mumbling to himself a lot.

(Source: Boku no Hero Academia Wikia)"

    assert_equal(actual, expected)

    assert(!(actual.include? '<br>'))
    assert(!(actual.include? '<br />'))
    assert(expected)
  end

  def test_parse_biography_spoilers
    #FIXME
  end

  def test_parse_animeography
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_animeography(nokogiri)
    expected =  [
        {
            'id': '31964',
            'name': 'Boku no Hero Academia',
            'url': '/anime/31964/Boku_no_Hero_Academia',
            'image_url': 'https://myanimelist.cdn-dena.com/images/anime/10/78745.jpg',
            'role': 'Main'
        },
        {
            'id': '33486',
            'name': 'Boku no Hero Academia 2nd Season',
            'url': '/anime/33486/Boku_no_Hero_Academia_2nd_Season',
            'image_url': 'https://myanimelist.cdn-dena.com/images/anime/3/84547.jpg',
            'role': 'Main'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_mangography
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_mangaography(nokogiri)
    expected =  [
        {
            'id': '75989',
            'name': 'Boku no Hero Academia',
            'url': '/manga/75989/Boku_no_Hero_Academia',
            'image_url': 'https://myanimelist.cdn-dena.com/images/manga/1/141381.jpg',
            'role': 'Main'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_voice_actors
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_voice_actors(nokogiri)
    expected =  [
        {
            'id': '94',
            'name': 'Watanabe, Akeno',
            'url': '/people/94/Akeno_Watanabe',
            'image_url': 'https://myanimelist.cdn-dena.com/images/voiceactors/1/17129.jpg',
            'language': 'Japanese'
        },
        {
            'id': '15441',
            'name': 'Woodhull, Lara',
            'url': '/people/15441/Lara_Woodhull',
            'image_url': 'https://myanimelist.cdn-dena.com/images/voiceactors/2/43356.jpg',
            'language': 'English'
        },
        {
            'id': '21971',
            'name': 'Yamashita, Daiki',
            'url': '/people/21971/Daiki_Yamashita',
            'image_url': 'https://myanimelist.cdn-dena.com/images/voiceactors/2/42618.jpg',
            'language': 'Japanese'
        },
        {
            'id': '37957',
            'name': 'Briner, Justin',
            'url': '/people/37957/Justin_Briner',
            'image_url': 'https://myanimelist.cdn-dena.com/images/voiceactors/2/43348.jpg',
            'language': 'English'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_favorited_count
    scraper = Railgun::CharacterScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_favorite_count(nokogiri)
    expected = 1898

    assert_equal(expected, actual)
  end

end