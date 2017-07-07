require File.dirname(__FILE__) + '/test_helper'

class TestStringFormatter < Test::Unit::TestCase

  def test_string_formatter_decoded_html

    string = 'K&ouml;ppel, Nicolai'

    actual = Railgun::StringFormatter.encodedHTML(string)
    expected = 'Köppel, Nicolai'

    assert_equal(expected, actual)
  end

  def test_string_formatter_decoded_html_star

    string = 'Mahou Shoujo Madoka&#9733;Magica'

    actual = Railgun::StringFormatter.encodedHTML(string)
    expected = 'Mahou Shoujo Madoka★Magica'

    assert_equal(expected, actual)
  end

  def test_string_formatter_no_decoded_html
    string = 'Köppel, Nicolai'

    actual = Railgun::StringFormatter.encodedHTML(string)
    expected = string

    assert_equal(expected, actual)
  end

end