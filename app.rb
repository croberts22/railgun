require 'sinatra'
require 'sinatra/namespace'
require 'rollbar/middleware/sinatra'
require 'rack-mini-profiler'
require 'flamegraph'
require_relative 'services/mal_network_service'
require_relative 'railgun'


class App < Sinatra::Base
  register Sinatra::Namespace
  use Rollbar::Middleware::Sinatra
  use Rack::MiniProfiler

  configure :production, :development do
    enable :logging
  end

  before do
    content_type 'application/json;charset=utf-8'
  end

  namespace '/1.0' do

    #
    # Anime Endpoints
    #

    # GET /anime/#{anime_id}
    # Get an anime's details.
    # Parameters:
    # - id: The anime's ID.
    # - options (optional): A comma-separated list of strings that define additional stats.
    #                       Available options include 'stats' and 'characters_and_staff'.
    get '/anime/:id' do
      pass unless params[:id] =~ /^\d+$/

      options = []

      if params.include? 'options'
        options = params[:options].split(',')
      end

      logger.info "Fetching anime with ID #{params[:id]}..."
      logger.info "Options: #{options}" unless options.count == 0

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "anime/#{params[:id]}/#{options}"

      anime = Railgun::Anime.scrape(params[:id], options)

      anime.to_json
    end

    # GET /anime?q=#{query}
    # Searches for an anime based on a given query.
    # Parameters:
    # - q: A search query.
    get '/anime?' do

      pass unless !params[:q].nil? && params[:q].strip.length > 0

      query = CGI.escape(params[:q].strip)

      # FIXME: Removing caching on search for now. Figure out how to better cache this
      #expires 3600, :public, :must_revalidate
      #last_modified Time.now
      #etag "anime?#{query}"

      results = Railgun::Anime.search(query)

      results.to_json
    end

    # GET /anime/top
    # Gets a page of a ranked list of anime. A page consists of 50 anime.
    # Parameters:
    # - type (optional): The type of list to fetch. Available options:
    #                    'all', 'airing', 'upcoming', 'tv', 'movie', 'ova', 'special', 'popular', 'favorite'.
    #                    If no type is provided, this defaults to 'all'.
    # - page (optional): The page of anime to fetch. If no value is provided, this defaults to 0.
    #                    Each page consists of 50 anime; fetching page 1 returns anime
    #                    ranked 51-100, page 2 returns 101-150, etc.
    get '/anime/top' do

      options = {
          type: 'all',
          page: 0
      }

      if params.include? 'type' and Railgun::MALNetworkService.rank_type_is_acceptable_for_anime_request(params[:type])
        options[:type] = params[:type]
      end

      if params.include? 'page' and params[:age].is_a? Integer
        options[:page] = params[:page]
      end

      logger.info "Fetching anime list with options #{options}..."

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "anime/top/#{options[:type]}/#{options[:page]}"

      anime = Railgun::Anime.top(options)

      anime.to_json

    end


    #
    # Manga Endpoints
    #


    # GET /manga/#{manga_id}
    # Get a manga's details.
    # Parameters:
    # - id: The manga's ID.
    # - options (optional): A comma-separated list of strings that define additional stats.
    #                       Available options include 'stats' and 'characters_and_staff'.
    get '/manga/:id' do
      pass unless params[:id] =~ /^\d+$/

      options = []

      if params.include? 'options'
        options = params[:options].split(',')
      end

      logger.info "Fetching manga with ID #{params[:id]}..."
      logger.info "Options: #{options}" unless options.count == 0

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "manga/#{params[:id]}/#{options}"

      manga = Railgun::Manga.scrape(params[:id], options)

      manga.to_json
    end

    # GET /manga?q=#{query}
    # Searches for a manga based on a given query.
    # Parameters:
    # - q: A search query.
    get '/manga?' do

      pass unless !params[:q].nil? && params[:q].strip.length > 0

      query = CGI.escape(params[:q].strip)

      # FIXME: Removing caching on search for now. Figure out how to better cache this
      #expires 3600, :public, :must_revalidate
      #last_modified Time.now
      #etag "manga?#{query}"

      results = Railgun::Manga.search(query)

      results.to_json
    end

  end

end