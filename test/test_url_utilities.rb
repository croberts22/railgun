require File.dirname(__FILE__) + '/test_helper'

class TestUrlUtilities < Test::Unit::TestCase

  def test_create_original_image_url_anime
    #https://myanimelist.cdn-dena.com/r/50x70/images/anime/8/53581.jpg?s=6f54a4bddfa95450cbf089d7f8783799
    image_url = 'https://myanimelist.cdn-dena.com/r/50x71/images/anime/2/73842.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce'

    actual = Railgun::UrlUtilities.create_original_image_url('anime', image_url)
    expected = 'https://myanimelist.cdn-dena.com/images/anime/2/73842.jpg'

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_manga
    image_url = 'https://myanimelist.cdn-dena.com/r/50x71/images/manga/2/73842.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = 'https://myanimelist.cdn-dena.com/images/manga/2/73842.jpg'

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_no_match
    image_url = 'https://myanimelist.cdn-dena.com/r/50x71/images/anime/2/73842.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = image_url

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_remove_t
    image_url = 'https://myanimelist.cdn-dena.com/r/50x71/images/manga/2/73842t.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = 'https://myanimelist.cdn-dena.com/images/manga/2/73842.jpg'

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_remove_v
    image_url = 'https://myanimelist.cdn-dena.com/images/voiceactors/2/43356v.jpg'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = 'https://myanimelist.cdn-dena.com/images/voiceactors/2/43356.jpg'

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_remove_thumbs_directory
    image_url = 'https://myanimelist.cdn-dena.com/images/userimages/thumbs/5346452.jpg'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = 'https://myanimelist.cdn-dena.com/images/userimages/5346452.jpg'

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_remove_thumb
    image_url = 'https://myanimelist.cdn-dena.com/images/userimages/5346452_thumb.jpg'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = 'https://myanimelist.cdn-dena.com/images/userimages/5346452.jpg'

    assert_equal(expected, actual)
  end

  def test_create_original_image_url_remove_thumb_complete
    image_url = 'https://myanimelist.cdn-dena.com/images/userimages/thumbs/5346452_thumb.jpg'

    actual = Railgun::UrlUtilities.create_original_image_url('manga', image_url)
    expected = 'https://myanimelist.cdn-dena.com/images/userimages/5346452.jpg'

    assert_equal(expected, actual)
  end

end