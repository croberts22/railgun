require File.dirname(__FILE__) + '/test_helper'
require_relative '../app'

class TestManga < Test::Unit::TestCase
  include Rack::Test::Methods

  # TODO: Create a mock app to simulate requests.
  # def app
  #   Sinatra::Application
  # end
  #
  # def test_manga
  #   get '/1.0/manga/1'
  #   assert last_response.ok?
  # end

  def test_status
    manga = Railgun::Manga.new

    # Finished Publishing.
    manga.status = 2
    assert_equal(:'finished', manga.status)

    manga.status = '2'
    assert_equal(:'finished', manga.status)

    manga.status = 'finished'
    assert_equal(:'finished', manga.status)

    manga.status = 'manga has finished'
    assert_equal(:'finished', manga.status)

    # Currently Publishing.
    manga.status = 1
    assert_equal(:'publishing', manga.status)

    manga.status = '1'
    assert_equal(:'publishing', manga.status)

    manga.status = 'publishing'
    assert_equal(:'publishing', manga.status)

    manga.status = 'manga is currently publishing'
    assert_equal(:'publishing', manga.status)

    # Not Yet Aired.
    manga.status = 3
    assert_equal(:'not yet published', manga.status)

    manga.status = '3'
    assert_equal(:'not yet published', manga.status)

    manga.status = 'not yet published'
    assert_equal(:'not yet published', manga.status)

    manga.status = 'manga has not yet published'
    assert_equal(:'not yet published', manga.status)

    # Unknown, defaults to Finished Publishing.
    manga.status = 'manga is about to publish'
    assert_equal(:'finished', manga.status)
  end

  def test_type
    manga = Railgun::Manga.new

    # Manga.
    manga.type = 'manga'
    assert_equal(:Manga, manga.type)

    manga.type = 'Manga'
    assert_equal(:Manga, manga.type)

    manga.type = '1'
    assert_equal(:Manga, manga.type)

    manga.type = 1
    assert_equal(:Manga, manga.type)

    # Novel.
    manga.type = 'novel'
    assert_equal(:Novel, manga.type)

    manga.type = 'Novel'
    assert_equal(:Novel, manga.type)

    manga.type = '2'
    assert_equal(:Novel, manga.type)

    manga.type = 2
    assert_equal(:Novel, manga.type)

    # One Shot.
    manga.type = 'one shot'
    assert_equal(:'One Shot', manga.type)

    manga.type = 'One Shot'
    assert_equal(:'One Shot', manga.type)

    manga.type = '3'
    assert_equal(:'One Shot', manga.type)

    manga.type = 3
    assert_equal(:'One Shot', manga.type)

    # Doujin.
    manga.type = 'doujin'
    assert_equal(:Doujin, manga.type)

    manga.type = 'Doujin'
    assert_equal(:Doujin, manga.type)

    manga.type = '4'
    assert_equal(:Doujin, manga.type)

    manga.type = 4
    assert_equal(:Doujin, manga.type)

    # Manwha.
    manga.type = 'manwha'
    assert_equal(:Manwha, manga.type)

    manga.type = 'Manwha'
    assert_equal(:Manwha, manga.type)

    manga.type = '5'
    assert_equal(:Manwha, manga.type)

    manga.type = 5
    assert_equal(:Manwha, manga.type)

    # Manhua.
    manga.type = 'manhua'
    assert_equal(:Manhua, manga.type)

    manga.type = 'Manhua'
    assert_equal(:Manhua, manga.type)

    manga.type = '6'
    assert_equal(:Manhua, manga.type)

    manga.type = 6
    assert_equal(:Manhua, manga.type)

    # OEL.
    manga.type = 'oel'
    assert_equal(:OEL, manga.type)

    manga.type = 'OEL'
    assert_equal(:OEL, manga.type)

    manga.type = '7'
    assert_equal(:OEL, manga.type)

    manga.type = 7
    assert_equal(:OEL, manga.type)

    # Other, defaults to Manga.
    manga.type = 'Book'
    assert_equal(:Manga, manga.type)

    manga.type = '10'
    assert_equal(:Manga, manga.type)

    manga.type = 9
    assert_equal(:Manga, manga.type)

  end

  def test_initialized_attributes
    manga = Railgun::Manga.new

    assert(manga.genres.empty?)
    assert(manga.other_names.empty?)
    assert(manga.anime_adaptations.empty?)
    assert(manga.prequels.empty?)
    assert(manga.sequels.empty?)
    assert(manga.side_stories.empty?)
    assert(manga.spin_offs.empty?)
    assert(manga.summaries.empty?)
    assert(manga.alternative_versions.empty?)
    assert(manga.alternative_settings.empty?)
    assert(manga.full_stories.empty?)
    assert(manga.others.empty?)
    assert(manga.parent_story.empty?)
    assert(manga.summary_stats.empty?)
    assert(manga.score_stats.empty?)
    assert(manga.additional_info_urls.empty?)
    assert(manga.character_voice_actors.empty?)
  end

end