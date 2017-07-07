require File.dirname(__FILE__) + '/test_helper'

class TestMALNetworkService < Test::Unit::TestCase

  ### Tests

  def test_create_request

    url = 'https://myanimelist.net/blah/'

    expected = Curl::Easy.new(url)
    expected.headers['User-Agent'] = Railgun::Keys.myanimelist_api_key

    actual = Railgun::MALNetworkService.create_request(url)

    assert_equal(expected.url, actual.url)
    assert_equal(expected.headers['User-Agent'], actual.headers['User-Agent'])

  end

  def test_anime_request_for_id
    id = 6213

    expected = "https://myanimelist.net/anime/#{id}"
    actual = Railgun::MALNetworkService.anime_request_for_id(id)

    assert_equal(expected, actual)
  end

  def test_anime_search_request_with_query
    query = 'toaru kagaku no railgun'

    expected = "https://myanimelist.net/anime.php?q=#{query}"
    actual = Railgun::MALNetworkService.anime_search_request_with_query(query)

    assert_equal(expected, actual)
  end

  def test_manga_request_for_id
    id = 6213

    expected = "https://myanimelist.net/manga/#{id}"
    actual = Railgun::MALNetworkService.manga_request_for_id(id)

    assert_equal(expected, actual)
  end

  def test_manga_search_request_with_query
    query = 'toaru kagaku no railgun'

    expected = "https://myanimelist.net/manga.php?q=#{query}"
    actual = Railgun::MALNetworkService.manga_search_request_with_query(query)

    assert_equal(expected, actual)
  end

  def test_anime_rank_request_valid_requests

    # No values. This defaults to 'all'.
    expected = 'https://myanimelist.net/topanime.php?type=all'
    actual = Railgun::MALNetworkService.anime_rank_request(nil, nil)

    assert_equal(expected, actual)

    # All.
    type = 'all'
    page = 0

    expected = 'https://myanimelist.net/topanime.php?type=all&page=0'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    # Airing.
    type = 'airing'
    page += 1

    expected = 'https://myanimelist.net/topanime.php?type=airing&page=1'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    # Upcoming.
    type = 'upcoming'
    page += 1

    expected = 'https://myanimelist.net/topanime.php?type=upcoming&page=2'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    # TV.
    type = 'tv'
    page += 1

    expected = 'https://myanimelist.net/topanime.php?type=tv&page=3'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    # Movie.
    type = 'movie'
    page += 1

    expected = 'https://myanimelist.net/topanime.php?type=movie&page=4'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    # OVA.
    type = 'ova'
    page += 1

    expected = 'https://myanimelist.net/topanime.php?type=ova&page=5'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    # Special.
    type = 'special'
    page += 1

    expected = 'https://myanimelist.net/topanime.php?type=special&page=6'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    # Popular.
    type = 'popular'
    page += 1

    expected = 'https://myanimelist.net/topanime.php?type=bypopularity&page=7'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    # Favorite.
    type = 'favorite'
    page += 1

    expected = 'https://myanimelist.net/topanime.php?type=favorite&page=8'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

  end

  def test_anime_rank_request_invalid_requests

    type = 'manga'
    page = 0

    expected = 'https://myanimelist.net/topanime.php?type=all&page=0'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    type = 'actor'
    page = 'next'

    expected = 'https://myanimelist.net/topanime.php?type=all'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

    type = 1337
    page = 'bad values here'

    expected = 'https://myanimelist.net/topanime.php?type=all'
    actual = Railgun::MALNetworkService.anime_rank_request(type, page)

    assert_equal(expected, actual)

  end

  def test_rank_type_is_acceptable_for_anime_request

    accepted_types = %w(all airing upcoming tv movie ova special popular favorite)
    accepted_types.each do |type|
      assert(Railgun::MALNetworkService.rank_type_is_acceptable_for_anime_request(type))
    end

    invalid_types = %w(manga reading publishing)
    invalid_types.each do |type|
      assert_false(Railgun::MALNetworkService.rank_type_is_acceptable_for_anime_request(type))
    end

  end

  def test_manga_rank_request_valid_requests

    # No values. This defaults to 'all'.
    expected = 'https://myanimelist.net/topmanga.php?type=all'
    actual = Railgun::MALNetworkService.manga_rank_request(nil, nil)

    assert_equal(expected, actual)

    # All.
    type = 'all'
    page = 0

    expected = 'https://myanimelist.net/topmanga.php?type=all&page=0'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    # Manga.
    type = 'manga'
    page += 1

    expected = 'https://myanimelist.net/topmanga.php?type=manga&page=1'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    # Novels.
    type = 'novels'
    page += 1

    expected = 'https://myanimelist.net/topmanga.php?type=novels&page=2'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    # One-shots.
    type = 'oneshots'
    page += 1

    expected = 'https://myanimelist.net/topmanga.php?type=oneshots&page=3'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    # Doujinshi.
    type = 'doujinshi'
    page += 1

    expected = 'https://myanimelist.net/topmanga.php?type=doujin&page=4'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    # Manhwa.
    type = 'manhwa'
    page += 1

    expected = 'https://myanimelist.net/topmanga.php?type=manhwa&page=5'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    # Manhua.
    type = 'manhua'
    page += 1

    expected = 'https://myanimelist.net/topmanga.php?type=manhua&page=6'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    # Popular.
    type = 'popular'
    page += 1

    expected = 'https://myanimelist.net/topmanga.php?type=bypopularity&page=7'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    # Favorite.
    type = 'favorite'
    page += 1

    expected = 'https://myanimelist.net/topmanga.php?type=favorite&page=8'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

  end

  def test_manga_rank_request_invalid_requests

    type = 'anime'
    page = 0

    expected = 'https://myanimelist.net/topmanga.php?type=all&page=0'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    type = 'actor'
    page = 'next'

    expected = 'https://myanimelist.net/topmanga.php?type=all'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

    type = 1337
    page = 'bad values here'

    expected = 'https://myanimelist.net/topmanga.php?type=all'
    actual = Railgun::MALNetworkService.manga_rank_request(type, page)

    assert_equal(expected, actual)

  end

  def test_rank_type_is_acceptable_for_manga_request
    accepted_types = %w(all manga novels oneshots doujinshi manhwa manhua popular favorite)
    accepted_types.each do |type|
      assert(Railgun::MALNetworkService.rank_type_is_acceptable_for_manga_request(type))
    end

    invalid_types = %w(anime writing airing broadcast tv movie ova)
    invalid_types.each do |type|
      assert_false(Railgun::MALNetworkService.rank_type_is_acceptable_for_manga_request(type))
    end

  end


end