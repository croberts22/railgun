require File.dirname(__FILE__) + '/test_helper'

class TestMangaScraper < Test::Unit::TestCase


  ### Convenience Methods

  def nokogiri_for_sample_response
    # Monogatari Series: First Season
    # https://myanimelist.net/manga/14893/Monogatari_Series__First_Season
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/manga_14893.html"))
  end

  def nokogiri_for_monogatari_2_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/monogatari_2_manga_response.html"))
  end

  def nokogiri_for_monogatari_side_story_response
    Nokogiri::HTML(File.read("#{File.dirname(__FILE__)}/html/monogatari_side_story_manga_response.html"))
  end

  def text_for_related_manga(nokogiri)
    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')
    related_manga_h2 = node.at('//h2[text()="Related Manga"]')

    if related_manga_h2
      match_data = related_manga_h2.parent.to_s.match(%r{</div>Related Manga</h2>(.+?)<h2>}m)
      match_data[1]
    end
  end


  ### Tests

  def test_parse_id
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_id(nokogiri)
    expected = '14893'

    assert_equal(expected, actual)
  end

  def test_parse_title
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_title(nokogiri)
    expected = 'Monogatari Series: First Season'

    assert_equal(expected, actual)
  end

  def test_parse_synopsis
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_synopsis(nokogiri)
    expected = 'This entry includes the first season of the Monogatari Series.'

    assert(!(actual.include? '<br>'))
    assert(!(actual.include? '<br />'))
    assert_equal(expected, actual)
  end

  def test_parse_rank
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_rank(nokogiri)
    expected = actual.is_a?(Integer)

    assert(expected)
  end

  def test_parse_image_url
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_image_url(nokogiri)
    expected = 'https://myanimelist.cdn-dena.com/images/manga/5/173535.jpg'

    assert_equal(expected, actual)
  end

  def test_parse_alternative_titles
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_alternative_titles(nokogiri)
    expected = {
        english:  ['Monogatari'],
        synonyms: ['Bakemonogatari', 'Kizumonogatari: Wound Tale', 'Nisemonogatari', 'Nekomonogatari: Kuro'],
        japanese: ['〈物語〉シリーズ ファーストシーズン']
    }

    assert_equal(expected, actual)
  end


  def test_parse_type
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_type(node)
    expected = 'Novel'

    assert_equal(expected, actual)
  end

  def test_parse_volume_count
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_volume_count(node)
    expected = 6

    assert_equal(expected, actual)
  end

  def test_parse_chapter_count
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_chapter_count(node)
    expected = 107

    assert_equal(expected, actual)
  end

  def test_parse_publishing_start_date
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_publishing_start_date(node)
    expected = Time.parse('Nov 1, 2006').utc.iso8601

    assert_equal(expected, actual)
  end

  def test_parse_publishing_end_date
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_publishing_end_date(node)
    expected = Time.parse('Jul 28, 2010').utc.iso8601

    assert_equal(expected, actual)
  end

  def test_parse_genres
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_genres(node)
    expected = %w( Action Mystery Romance Vampire Supernatural Comedy )

    expected.each { |genre| assert(actual.include? genre) }

  end

  def test_parse_score
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_score(node)
    expected = actual.is_a?(Float)

    assert(expected)
  end

  def test_parse_popularity_rank
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_popularity_rank(node)
    expected = actual.is_a?(Integer)

    assert(expected)
  end

  def test_parse_member_count
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_member_count(node)
    expected = actual.is_a?(Integer)

    assert(expected)
  end

  def test_parse_favorite_count
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_favorite_count(node)
    expected = actual.is_a?(Integer)

    assert(expected)
  end

  def test_parse_tags

  end

  def test_parse_additional_info_urls
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    node = nokogiri.xpath('//div[@id="content"]/table/tr/td[@class="borderClass"]')

    actual = scraper.parse_additional_info_urls(node)
    expected = {
        details: '/manga/14893/Monogatari_Series__First_Season',
        reviews: '/manga/14893/Monogatari_Series__First_Season/reviews',
        recommendations: '/manga/14893/Monogatari_Series__First_Season/userrecs',
        stats: '/manga/14893/Monogatari_Series__First_Season/stats',
        characters_and_staff: '/manga/14893/Monogatari_Series__First_Season/characters',
        news: '/manga/14893/Monogatari_Series__First_Season/news',
        forum: '/manga/14893/Monogatari_Series__First_Season/forum',
        pictures: '/manga/14893/Monogatari_Series__First_Season/pics'
    }

    assert_equal(expected, actual)

  end

  def test_parse_anime_adaptations
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    related_manga_text = text_for_related_manga(nokogiri)

    actual = scraper.parse_anime_adaptations(related_manga_text).sort_by { |item| item[:title] }
    expected = [
        {
            id: '31758',
            title: 'Kizumonogatari III: Reiketsu-hen',
            url: '/anime/31758/Kizumonogatari_III__Reiketsu-hen'
        },
        {
            id: '5081',
            title: 'Bakemonogatari',
            url: '/anime/5081/Bakemonogatari'
        },
        {
            id: '11597',
            title: 'Nisemonogatari',
            url: '/anime/11597/Nisemonogatari'
        },
        {
            id: '31757',
            title: 'Kizumonogatari II: Nekketsu-hen',
            url: '/anime/31757/Kizumonogatari_II__Nekketsu-hen'
        },
        {
            id: '9260',
            title: 'Kizumonogatari I: Tekketsu-hen',
            url: '/anime/9260/Kizumonogatari_I__Tekketsu-hen'
        },
        {
            id: '15689',
            title: 'Nekomonogatari: Kuro',
            url: '/anime/15689/Nekomonogatari__Kuro'
        }
    ].sort_by { |item| item[:title] }

    assert_equal(expected, actual)
  end

  def test_parse_prequels
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_monogatari_2_response

    related_manga_text = text_for_related_manga(nokogiri)

    actual = scraper.parse_prequels(related_manga_text)
    expected = [
        {
            id: '14893',
            title: 'Monogatari Series: First Season',
            url: '/manga/14893/Monogatari_Series__First_Season'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_sequels
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    related_manga_text = text_for_related_manga(nokogiri)

    actual = scraper.parse_sequels(related_manga_text)
    expected = [
        {
            id: '23751',
            title: 'Monogatari Series: Second Season',
            url: '/manga/23751/Monogatari_Series__Second_Season'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_side_stories
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    related_manga_text = text_for_related_manga(nokogiri)

    actual = scraper.parse_side_stories(related_manga_text).sort_by { |item| item[:title] }
    expected = [
        {
            id: '24499',
            title: 'Bakemonogatari Short Stories',
            url: '/manga/24499/Bakemonogatari_Short_Stories'
        },
        {
            id: '86670',
            title: 'Monogatari Series Heroine Hon',
            url: '/manga/86670/Monogatari_Series_Heroine_Hon'
        },
        {
            id: '90322',
            title: 'Nisemonogatari Short Stories',
            url: '/manga/90322/Nisemonogatari_Short_Stories'
        },
        {
            id: '93097',
            title: 'Monogatari Series: Off Season',
            url: '/manga/93097/Monogatari_Series__Off_Season'
        }
    ].sort_by { |item| item[:title] }

    assert_equal(expected, actual)
  end

  def test_parse_parent_story
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_monogatari_side_story_response

    related_manga_text = text_for_related_manga(nokogiri)

    actual = scraper.parse_parent_story(related_manga_text)
    expected = {
            id: '23751',
            title: 'Monogatari Series: Second Season',
            url: '/manga/23751/Monogatari_Series__Second_Season'
    }

    assert_equal(expected, actual)
  end

  def test_parse_spin_offs
    # scraper = Railgun::MangaScraper.new
    # nokogiri = nokogiri_for_railgun_response
    #
    # related_manga_text = text_for_related_manga(nokogiri)
    #
    # actual = scraper.parse_spin_offs(related_manga_text)
    # expected = [
    #     {
    #         id: '8023',
    #         title: 'Toaru Kagaku no Railgun Specials',
    #         url: '/manga/8023/Toaru_Kagaku_no_Railgun_Specials'
    #     }
    # ]
    #
    # assert_equal(expected, actual)
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
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_monogatari_2_response

    related_manga_text = text_for_related_manga(nokogiri)

    actual = scraper.parse_other(related_manga_text)
    expected = [
        {
            id: '66695',
            title: 'Kimi to Nadekko!',
            url: '/manga/66695/Kimi_to_Nadekko'
        }
    ]

    assert_equal(expected, actual)
  end

  def test_parse_manga
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    manga = Railgun::Manga.new
    scraper.parse_manga(nokogiri, manga)

    assert(!manga.id.nil?)
    assert(!manga.title.nil?)
    assert(!manga.synopsis.nil?)
    assert(!manga.rank.nil?)
    assert(!manga.image_url.nil?)
    assert_not_equal('http://cdn.myanimelist.net/images/spacer.gif', manga.image_url)
    assert(!manga.other_titles.empty?)
    assert(!manga.type.nil?)
    assert(manga.volumes > 0)
    assert(manga.chapters > 0)
    assert(!manga.start_date.nil?)
    assert(!manga.end_date.nil?)
    assert(!manga.genres.empty?)

  end

  def test_reviews
    scraper = Railgun::MangaScraper.new
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

  def test_authors
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_authors(nokogiri)
    expected = [
        {
            id: '5254',
            name: 'Nisio, Isin',
            responsibility: 'Story',
            url: '/people/5254/Isin_Nisio'
        },
        {
            id: '8594',
            name: 'VOFAN',
            responsibility: 'Art',
            url: '/people/8594/VOFAN'
        }
    ]

    assert_equal(expected, actual)

  end

  def test_serialization
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_serialization(nokogiri)
    expected = {
            id: '498',
            name: 'Mephisto',
            url: '/manga/magazine/498/Mephisto'
        }

    assert_equal(expected, actual)

  end


  def test_recommendations
    scraper = Railgun::MangaScraper.new
    nokogiri = nokogiri_for_sample_response

    actual = scraper.parse_recommendations(nokogiri, '14893')

    actual.each do |recommendation|

      assert(recommendation[:id].nil? == false)
      assert(recommendation[:id].is_a? String)

      assert(recommendation[:url].nil? == false)
      assert(recommendation[:url].is_a? String)

      assert(recommendation[:recommended_user_count].nil? == false)
      assert(recommendation[:recommended_user_count].is_a? Integer)

      resource = recommendation['manga']

      assert(resource.nil? == false)
      assert(resource.is_a? Hash)

      assert(resource[:id].nil? == false)
      assert(resource[:id].is_a? String)

      assert(resource[:title].nil? == false)
      assert(resource[:title].is_a? String)

      assert(resource[:image_url].nil? == false)
      assert(resource[:image_url].is_a? String)

    end

  end

end