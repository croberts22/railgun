require File.dirname(__FILE__) + '/test_helper'

class TestAnimeScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/shirobako_anime_response.html"))
  end

  def nokogiri_for_railgun_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/railgun_anime_response.html"))
  end

  def text_for_related_anime(nokogiri)
    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')
    related_anime_h2 = node.at('//h2[text()="Related Anime"]')

    if related_anime_h2
      match_data = related_anime_h2.parent.to_s.match(%r{</div>Related Anime</h2>(.+?)<h2>}m)
      match_data[1]
    end
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

  def test_parse_score
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_score(node)
    expected = 8.5

    assert_equal(expected, actual)
  end

  def test_parse_popularity_rank
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_popularity_rank(node)
    expected = 431

    assert_equal(expected, actual)
  end

  def test_parse_member_count
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_member_count(node)
    expected = 93735

    assert_equal(expected, actual)
  end

  def test_parse_favorite_count
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_favorite_count(node)
    expected = 1936

    assert_equal(expected, actual)
  end

  def test_parse_tags

  end

  def test_parse_additional_info_urls
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_additional_info_urls(node)
    expected = {
        details: 'http://myanimelist.net/anime/25835/Shirobako',
        reviews: 'http://myanimelist.net/anime/25835/Shirobako/reviews',
        recommendations: 'http://myanimelist.net/anime/25835/Shirobako/userrecs',
        stats: 'http://myanimelist.net/anime/25835/Shirobako/stats',
        characters_and_staff: 'http://myanimelist.net/anime/25835/Shirobako/characters',
        news: 'http://myanimelist.net/anime/25835/Shirobako/news',
        forum: 'http://myanimelist.net/anime/25835/Shirobako/forum',
        pictures: 'http://myanimelist.net/anime/25835/Shirobako/pics',
    }

    assert_equal(expected, actual)

  end

  def test_parse_manga_adaptations
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_manga_adaptations(related_anime_text)
    expected = [
        {
            manga_id: '80441',
            title: 'Shirobako: Kaminoyama Koukou Animation Doukoukai',
            url: '/manga/80441/Shirobako__Kaminoyama_Koukou_Animation_Doukoukai'
        },
        {
            manga_id: '84949',
            title: 'Shirobako: Introduction',
            url: '/manga/84949/Shirobako__Introduction'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_prequels

  end

  def test_parse_sequels
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_sequels(related_anime_text)
    expected = [
        {
            anime_id: '16049',
            title: 'Toaru Kagaku no Railgun S',
            url: '/anime/16049/Toaru_Kagaku_no_Railgun_S'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_side_stories
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_side_stories(related_anime_text)
    expected = [
        {
            anime_id: '9047',
            title: 'Toaru Kagaku no Railgun: Misaka-san wa Ima Chuumoku no Mato Desukara',
            url: '/anime/9047/Toaru_Kagaku_no_Railgun__Misaka-san_wa_Ima_Chuumoku_no_Mato_Desukara'
        },
        {
            anime_id: '9063',
            title: 'Toaru Kagaku no Railgun: Entenka no Satsuei Model mo Raku Ja Arimasen wa ne.',
            url: '/anime/9063/Toaru_Kagaku_no_Railgun__Entenka_no_Satsuei_Model_mo_Raku_Ja_Arimasen_wa_ne'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_parent_story
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_parent_story(related_anime_text)
    expected = {
        anime_id: '4654',
        title: 'Toaru Majutsu no Index',
        url: '/anime/4654/Toaru_Majutsu_no_Index'
    }

    assert_equal(expected, actual)
  end

  def test_parse_character_anime
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_character_anime(related_anime_text)
    expected = [
        {
            anime_id: '27509',
            title: 'Toaru Majutsu no Index 10th Anniversary PV',
            url: '/anime/27509/Toaru_Majutsu_no_Index_10th_Anniversary_PV'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_spin_offs
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_spin_offs(related_anime_text)
    expected = [
        {
            anime_id: '8023',
            title: 'Toaru Kagaku no Railgun Specials',
            url: '/anime/8023/Toaru_Kagaku_no_Railgun_Specials'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_summaries

  end

  def test_parse_alternative_versions

  end

  def test_parse_alternative_settings

  end

  def test_parse_full_stories

  end

  def test_parse_other

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