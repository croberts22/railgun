require File.dirname(__FILE__) + '/test_helper'
require_relative '../app'

class TestAnime < Test::Unit::TestCase
  include Rack::Test::Methods

  # TODO: Create a mock app to simulate requests.
  # def app
  #   Sinatra::Application
  # end
  #
  # def test_anime
  #   get '/1.0/anime/1'
  #   assert last_response.ok?
  # end

  def test_status
    anime = Railgun::Anime.new

    # Finished Airing.
    anime.status = 2
    assert_equal(:'finished airing', anime.status)

    anime.status = '2'
    assert_equal(:'finished airing', anime.status)

    anime.status = 'finished airing'
    assert_equal(:'finished airing', anime.status)

    anime.status = 'anime has finished airing'
    assert_equal(:'finished airing', anime.status)

    # Currently Airing.
    anime.status = 1
    assert_equal(:'currently airing', anime.status)

    anime.status = '1'
    assert_equal(:'currently airing', anime.status)

    anime.status = 'currently airing'
    assert_equal(:'currently airing', anime.status)

    anime.status = 'anime is currently airing'
    assert_equal(:'currently airing', anime.status)

    # Not Yet Aired.
    anime.status = 3
    assert_equal(:'not yet aired', anime.status)

    anime.status = '3'
    assert_equal(:'not yet aired', anime.status)

    anime.status = 'not yet aired'
    assert_equal(:'not yet aired', anime.status)

    anime.status = 'anime has not yet aired'
    assert_equal(:'not yet aired', anime.status)

    # Unknown, defaults to Finished Airing.
    anime.status = 'anime is about to air'
    assert_equal(:'finished airing', anime.status)
  end

  def test_type
    anime = Railgun::Anime.new

    # TV.
    anime.type = 'tv'
    assert_equal(:TV, anime.type)

    anime.type = 'TV'
    assert_equal(:TV, anime.type)

    anime.type = '1'
    assert_equal(:TV, anime.type)

    anime.type = 1
    assert_equal(:TV, anime.type)

    # OVA.
    anime.type = 'ova'
    assert_equal(:OVA, anime.type)

    anime.type = 'OVA'
    assert_equal(:OVA, anime.type)

    anime.type = '2'
    assert_equal(:OVA, anime.type)

    anime.type = 2
    assert_equal(:OVA, anime.type)

    # Movie.
    anime.type = 'movie'
    assert_equal(:Movie, anime.type)

    anime.type = 'Movie'
    assert_equal(:Movie, anime.type)

    anime.type = '3'
    assert_equal(:Movie, anime.type)

    anime.type = 3
    assert_equal(:Movie, anime.type)

    # Special.
    anime.type = 'special'
    assert_equal(:Special, anime.type)

    anime.type = 'Special'
    assert_equal(:Special, anime.type)

    anime.type = '4'
    assert_equal(:Special, anime.type)

    anime.type = 4
    assert_equal(:Special, anime.type)

    # ONA.
    anime.type = 'ona'
    assert_equal(:ONA, anime.type)

    anime.type = 'ONA'
    assert_equal(:ONA, anime.type)

    anime.type = '5'
    assert_equal(:ONA, anime.type)

    anime.type = 5
    assert_equal(:ONA, anime.type)

    # Music.
    anime.type = 'music'
    assert_equal(:Music, anime.type)

    anime.type = 'Music'
    assert_equal(:Music, anime.type)

    anime.type = '6'
    assert_equal(:Music, anime.type)

    anime.type = 6
    assert_equal(:Music, anime.type)

    # Other, defaults to TV.
    anime.type = 'Feature'
    assert_equal(:TV, anime.type)

    anime.type = '10'
    assert_equal(:TV, anime.type)

    anime.type = 9
    assert_equal(:TV, anime.type)

  end

  def test_initialized_attributes
    anime = Railgun::Anime.new

    assert(anime.genres.empty?)
    assert(anime.other_titles.empty?)
    assert(anime.manga_adaptations.empty?)
    assert(anime.prequels.empty?)
    assert(anime.sequels.empty?)
    assert(anime.side_stories.empty?)
    assert(anime.character_anime.empty?)
    assert(anime.spin_offs.empty?)
    assert(anime.summaries.empty?)
    assert(anime.alternative_versions.empty?)
    assert(anime.alternative_settings.empty?)
    assert(anime.full_stories.empty?)
    assert(anime.others.empty?)
    assert(anime.parent_story.empty?)
    assert(anime.summary_stats.empty?)
    assert(anime.score_stats.empty?)
    assert(anime.additional_info_urls.empty?)
    assert(anime.character_voice_actors.empty?)
  end

end