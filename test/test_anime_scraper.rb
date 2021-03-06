require File.dirname(__FILE__) + '/test_helper'

class TestAnimeScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    # Shirobako
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/anime_25835.html"))
  end

  def nokogiri_for_shirobako_stats_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/shirobako_stats_anime_response.html"))
  end

  def nokogiri_for_railgun_s_characters_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/railgun_s_characters_anime_response.html"))
  end

  def nokogiri_for_railgun_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/railgun_anime_response.html"))
  end

  def nokogiri_for_railgun_s_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/railgun_s_anime_response.html"))
  end

  def nokogiri_for_sample_response_no_recommendations
    # To Love-RU Darkness (2017)
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/anime_35000.html"))
  end

  def nokogiri_for_autorecommendations
    # Fairy Tail Movie 1: Houou no Miko - Hajimari no Asa
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/anime_17535.html"))
  end

  def nokogiri_for_blank_image
    # ReLIFE Kanketsu-hen
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/anime_35466.html"))
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
    expected = '25835'

    assert_equal(expected, actual)
  end

  def test_parse_name
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_name(nokogiri)
    expected = 'Shirobako'

    assert_equal(expected, actual)
  end

  def test_parse_synopsis
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_synopsis(nokogiri)
    expected = actual.is_a?(String)

    assert(!(actual.include? '<br>'))
    assert(!(actual.include? '<br />'))
    assert(expected)
  end

  def test_parse_rank
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_rank(nokogiri)
    expected = actual.is_a?Integer

    assert(expected)
  end

  def test_parse_image_url
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_image_url(nokogiri)
    expected = 'https://myanimelist.cdn-dena.com/images/anime/6/68021.jpg'

    assert_equal(expected, actual)
  end

  def test_parse_alternative_names
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_alternative_names(nokogiri)
    expected = {
        english: ['Shirobako'],
        japanese: ['SHIROBAKO'],
        synonyms: ['White Box']
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
    expected = Time.parse('Oct 9, 2014').utc.iso8601

    assert_equal(expected, actual)
  end

  def test_parse_airing_end_date
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_airing_end_date(node)
    expected = Time.parse('Mar 26, 2015').utc.iso8601

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
    expected = actual.is_a?(Float)

    assert(expected)
  end

  def test_parse_popularity_rank
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_popularity_rank(node)
    expected = actual.is_a?Integer

    assert(expected)
  end

  def test_parse_premiere_season
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_premiere_season(node)
    expected = 'fall'

    assert_equal(expected, actual)
  end

  def test_parse_premiere_year
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_premiere_year(node)
    expected = 2014

    assert_equal(expected, actual)
  end

  def test_parse_member_count
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_member_count(node)
    expected = actual.is_a?Integer

    assert(expected)
  end

  def test_parse_favorite_count
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_favorite_count(node)
    expected = actual.is_a?Integer

    assert(expected)
  end

  def test_parse_tags

  end

  def test_parse_additional_info_urls
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_additional_info_urls(node)
    expected = {
        details: 'https://myanimelist.net/anime/25835/Shirobako',
        reviews: 'https://myanimelist.net/anime/25835/Shirobako/reviews',
        recommendations: 'https://myanimelist.net/anime/25835/Shirobako/userrecs',
        stats: 'https://myanimelist.net/anime/25835/Shirobako/stats',
        characters_and_staff: 'https://myanimelist.net/anime/25835/Shirobako/characters',
        news: 'https://myanimelist.net/anime/25835/Shirobako/news',
        forum: 'https://myanimelist.net/anime/25835/Shirobako/forum',
        pictures: 'https://myanimelist.net/anime/25835/Shirobako/pics',
    }

    assert_equal(expected, actual)

  end

  def test_parse_manga_adaptations
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_manga_adaptations(related_anime_text).sort_by { |item| item[:name] }
    expected = [
        {
            id: '80441',
            name: 'Shirobako: Kaminoyama Koukou Animation Doukoukai',
            url: '/manga/80441/Shirobako__Kaminoyama_Koukou_Animation_Doukoukai'
        },
        {
            id: '84949',
            name: 'Shirobako: Introduction',
            url: '/manga/84949/Shirobako__Introduction'
        }
    ].sort_by { |item| item[:name] }

    assert_equal(expected, actual)
  end

  def test_parse_prequels
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_s_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_prequels(related_anime_text)
    expected = [
        {
            id: '6213',
            name: 'Toaru Kagaku no Railgun',
            url: '/anime/6213/Toaru_Kagaku_no_Railgun'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_sequels
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_sequels(related_anime_text)
    expected = [
        {
            id: '16049',
            name: 'Toaru Kagaku no Railgun S',
            url: '/anime/16049/Toaru_Kagaku_no_Railgun_S'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_side_stories
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_side_stories(related_anime_text).sort_by { |item| item[:name] }
    expected = [
        {
            id: '9047',
            name: 'Toaru Kagaku no Railgun: Misaka-san wa Ima Chuumoku no Mato desukara',
            url: '/anime/9047/Toaru_Kagaku_no_Railgun__Misaka-san_wa_Ima_Chuumoku_no_Mato_desukara'
        },
        {
            id: '9063',
            name: 'Toaru Kagaku no Railgun: Entenka no Satsuei Model mo Raku Ja Arimasen wa ne.',
            url: '/anime/9063/Toaru_Kagaku_no_Railgun__Entenka_no_Satsuei_Model_mo_Raku_Ja_Arimasen_wa_ne'
        }
    ].sort_by { |item| item[:name] }

    assert_equal(expected, actual)
  end

  def test_parse_parent_story
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_parent_story(related_anime_text)
    expected = {
        id: '4654',
        name: 'Toaru Majutsu no Index',
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
            id: '27509',
            name: 'Toaru Majutsu no Index 10th Anniversary PV',
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
            id: '8023',
            name: 'Toaru Kagaku no Railgun: Motto Marutto Railgun',
            url: '/anime/8023/Toaru_Kagaku_no_Railgun__Motto_Marutto_Railgun'
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
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_s_response

    related_anime_text = text_for_related_anime(nokogiri)

    actual = scraper.parse_other(related_anime_text)
    expected = [
        {
            id: '22759',
            name: 'Toaru Kagaku no Railgun S: Daiji na Koto wa Zenbu Sentou ni Osowatta',
            url: '/anime/22759/Toaru_Kagaku_no_Railgun_S__Daiji_na_Koto_wa_Zenbu_Sentou_ni_Osowatta'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_anime
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    anime = Railgun::Anime.new('25835')
    scraper.parse_anime(nokogiri, anime)

    assert(!anime.id.nil?)
    assert(!anime.name.nil?)
    assert(!anime.synopsis.nil?)
    assert(!anime.rank.nil?)
    assert(!anime.image_url.nil?)
    assert_not_equal('http://cdn.myanimelist.net/images/spacer.gif', anime.image_url)
    assert(!anime.other_names.empty?)
    assert(!anime.type.nil?)
    assert(anime.episodes > 0)
    assert(!anime.start_date.nil?)
    assert(!anime.end_date.nil?)
    assert(!anime.genres.empty?)
    assert(!anime.classification.nil?)

  end

  def test_parse_additional_stats
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_shirobako_stats_response

    actual = scraper.parse_summary_stats(nokogiri)

    actual.each do | key, value |
      assert(value.is_a?Integer)
    end

    actual = scraper.parse_score_stats(nokogiri)

    actual.each do | key, value |
      assert(value.is_a?Integer)
    end

  end

  def test_parse_characters_and_staff
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_railgun_s_characters_response

    actual = scraper.parse_staff(nokogiri)

    actual.each { |pair|
      character = pair[:character]

      assert(!character[:name].empty?)
      assert(!character[:id].empty?)
      assert(!character[:url].empty?)
      assert(!character[:role].empty?)
      assert(!character[:image_url].empty?)
      assert_not_equal('http://cdn.myanimelist.net/images/spacer.gif', character[:image_url])

      voice_actors = pair[:voice_actor]

      voice_actors.each { |actor|
        assert(!actor[:name].empty?)
        assert(!actor[:id].empty?)
        assert(!actor[:url].empty?)
        assert(!actor[:language].empty?)
        assert(!actor[:image_url].empty?)
        assert_not_equal('http://cdn.myanimelist.net/images/spacer.gif',actor[:image_url])
      }
    }

  end

  def test_reviews
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    reviews_h2 = nokogiri.at('//h2[text()="Reviews"]')
    if reviews_h2
      # Get all text between "Reviews</h2>" and the next </h2> tag.
      matched_data = reviews_h2.parent.to_s.match(%r{Reviews</h2>(.+?)<h2>}m)
      if matched_data

        data = matched_data[1].gsub(/>\s+</, '><')
        reviews_nokogiri = Nokogiri::HTML(data)

        reviews = scraper.parse_reviews(reviews_nokogiri)

        assert(reviews.count > 0)

        reviews.each do |review|

          # User
          assert(!review.username.empty?)
          assert(!review.user_url.empty?)
          assert(!review.user_image_url.empty?)

          # Metadata
          assert(review.helpful_review_count.is_a? Integer)
          assert(review.helpful_review_count > 0)
          assert(review.date.is_a? String)
          assert(review.episodes_watched.is_a? Integer)
          assert(review.episodes_watched > 0)
          assert(review.episodes_total.is_a? Integer)
          assert(review.episodes_total > 0)

          # Ratings
          unless review.rating[:overall].nil?
            assert(review.rating[:overall].is_a? Integer)
            assert(review.rating[:overall] > 0)
          end

          unless review.rating[:story].nil?
            assert(review.rating[:story].is_a? Integer)
            assert(review.rating[:story] > 0)
          end

          unless review.rating[:animation].nil?
            assert(review.rating[:animation].is_a? Integer)
            assert(review.rating[:animation] > 0)
          end

          unless review.rating[:sound].nil?
            assert(review.rating[:sound].is_a? Integer)
            assert(review.rating[:sound] > 0)
          end

          unless review.rating[:character].nil?
            assert(review.rating[:character].is_a? Integer)
            assert(review.rating[:character] > 0)
          end

          unless review.rating[:enjoyment].nil?
            assert(review.rating[:enjoyment].is_a? Integer)
            assert(review.rating[:enjoyment] > 0)
          end


          # Review
          assert_not_nil(review.review)
          assert_false(review.review.include? '<br>')

        end

      end
    end

  end

  def test_producers
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_producers(nokogiri)

    expected = [{
                    id: '64',
                    name: 'Sotsu',
                    url: '/anime/producer/64/Sotsu'
                },
                {
                    id: '166',
                    name: 'Movic',
                    url: '/anime/producer/166/Movic'
                },
                {
                    id: '415',
                    name: 'Warner Bros.',
                    url: '/anime/producer/415/Warner_Bros'
                },
                {
                    id: '460',
                    name: 'KlockWorx',
                    url: '/anime/producer/460/KlockWorx'
                },
                {
                    id: '777',
                    name: 'Showgate',
                    url: '/anime/producer/777/Showgate'
                },
                {
                    id: '1386',
                    name: 'Infinite',
                    url: '/anime/producer/1386/Infinite'
                }]

    actual.each do |producer|
        assert(expected.include?(producer))
    end

  end

  def test_studios
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_studios(nokogiri)
    expected = [{
        id: '132',
        name: 'P.A. Works',
        url: '/anime/producer/132/PA_Works'
    }]

    actual.each do |studio|
      assert(expected.include?(studio))
    end

    assert_equal(expected, actual)
  end

  def test_score_count
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_score_count(nokogiri)
    expected = 55311

    assert_equal(expected, actual)
  end

  def test_recommendations
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_recommendations(nokogiri, '25835')

    actual.each do |recommendation|

      assert(recommendation[:id].nil? == false)
      assert(recommendation[:id].is_a? String)

      assert(recommendation[:url].nil? == false)
      assert(recommendation[:url].is_a? String)

      assert(recommendation[:recommended_user_count].nil? == false)
      assert(recommendation[:recommended_user_count].is_a? Integer)

      resource = recommendation['anime']

      assert(resource.nil? == false)
      assert(resource.is_a? Hash)

      assert(resource[:id].nil? == false)
      assert(resource[:id].is_a? String)

      assert(resource[:name].nil? == false)
      assert(resource[:name].is_a? String)

      assert(resource[:image_url].nil? == false)
      assert(resource[:image_url].is_a? String)

    end

  end

  def test_recommendations_autorecommendations
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_autorecommendations

    actual = scraper.parse_recommendations(nokogiri, '17535')

    actual.each do |recommendation|

      assert(recommendation[:id].nil? == false)
      assert(recommendation[:id].is_a? String)
      assert_false(recommendation[:id].include? 'suggestion')

      assert(recommendation[:url].nil? == false)
      assert(recommendation[:url].is_a? String)
      assert_false(recommendation[:url].include? 'suggestion')

      assert(recommendation[:recommended_user_count].nil? == false)
      assert(recommendation[:recommended_user_count].is_a? Integer)

      resource = recommendation['anime']

      assert(resource.nil? == false)
      assert(resource.is_a? Hash)

      assert(resource[:id].nil? == false)
      assert(resource[:id].is_a? String)
      assert_false(resource[:id].include? 'suggestion')

      assert(resource[:name].nil? == false)
      assert(resource[:name].is_a? String)

      assert(resource[:image_url].nil? == false)
      assert(resource[:image_url].is_a? String)

    end

  end

  def test_recommendations_none
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response_no_recommendations

    actual = scraper.parse_recommendations(nokogiri, '35000')
    expected = []

    assert_equal(expected, actual)

  end

  def test_parse_source
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_source(nokogiri)
    expected = 'Original'

    assert_equal(expected, actual)
  end

  def test_parse_image_url_no_affiliates
    scraper = Railgun::AnimeScraper.new
    nokogiri = nokogiri_for_blank_image

    actual = scraper.parse_image_url(nokogiri)

    assert_nil(actual)
  end

end