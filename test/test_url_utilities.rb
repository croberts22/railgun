require File.dirname(__FILE__) + '/test_helper'

class TestUrlUtilities < Test::Unit::TestCase

  def test_create_original_image_url_anime
    image_url = 'http://cdn.myanimelist.net/r/50x71/images/anime/2/73842.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce'

    actual = Railgun::UrlUtilities.create_original_image_url('anime', image_url)
    expected = 'http://cdn.myanimelist.net/images/anime/2/73842.jpg'

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_manga
    image_url = 'http://cdn.myanimelist.net/r/50x71/images/manga/2/73842.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = 'http://cdn.myanimelist.net/images/manga/2/73842.jpg'

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_no_match
    image_url = 'http://cdn.myanimelist.net/r/50x71/images/anime/2/73842.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = image_url

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_remove_t
    image_url = 'http://cdn.myanimelist.net/r/50x71/images/manga/2/73842t.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = 'http://cdn.myanimelist.net/images/manga/2/73842.jpg'

    assert_equal(expected, actual)
  end

end