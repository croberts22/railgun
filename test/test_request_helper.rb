require File.dirname(__FILE__) + '/test_helper'
require_relative '../utilities/request_helper'

class TestRequestHelper < Test::Unit::TestCase

  ### Tests

  def test_etag_default

    resource = 'test'
    id = '1337'
    date = Date.parse('2018-01-05')
    offset = 1
    tag = Railgun::RequestHelper.generate_etag(resource, id, date, offset)

    actual = tag
    expected = Digest::MD5.hexdigest "#{resource}-#{id}-#{date.yday / offset}"

    assert_equal(expected, actual)

  end

  def test_etag_offset

    resource = 'test'
    id = '1337'
    date = Date.parse('2018-01-06')
    offset = 2
    tag = Railgun::RequestHelper.generate_etag(resource, id, date, offset)

    actual = tag
    expected = Digest::MD5.hexdigest "#{resource}-#{id}-#{date.yday / offset}"

    assert_equal(expected, actual)

    # Updating the date by one should not impact the etag value.
    date = date.next_day
    tag = Railgun::RequestHelper.generate_etag(resource, id, date, offset)

    actual = tag

    assert_equal(expected, actual)

  end

  def test_etag_offset_large

    resource = 'test'
    id = '1337'
    date = Date.parse('2018-01-05')
    offset = 5
    tag = Railgun::RequestHelper.generate_etag(resource, id, date, offset)

    actual = tag
    expected = Digest::MD5.hexdigest "#{resource}-#{id}-#{date.yday / offset}"

    assert_equal(expected, actual)

    for i in 1..offset-1
      # Updating the date by one should not impact the etag value.
      date = date.next_day
      tag = Railgun::RequestHelper.generate_etag(resource, id, date, offset)

      actual = tag

      assert_equal(expected, actual)
    end



  end

end