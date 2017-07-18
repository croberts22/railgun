require 'sinatra'
require 'sinatra/namespace'
require 'rollbar/middleware/sinatra'
require 'redis'
require_relative 'lib/redis_cache'
require_relative 'services/mal_network_service'
require_relative 'railgun'


class App < Sinatra::Base
  register Sinatra::Namespace
  use Rollbar::Middleware::Sinatra

  redis = Redis.new

  configure :production, :development do
    enable :logging
  end

  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type 'application/json;charset=utf-8'
  end

  configure do
    # enable :sessions, :static, :methodoverride
    # disable :raise_errors

    set :public_folder, Proc.new { File.join(File.dirname(__FILE__), 'public') }

    # JSON CSRF protection interferes with CORS requests. Seeing as we're only acting
    # as a proxy and not dealing with sensitive information, we'll disable this to
    # prevent all manner of headaches.
    # set :protection, :except => :json_csrf
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

      # FIXME: Removing caching on search for now. Figure out how to better cache this
      # expires 3600, :public, :must_revalidate
      # last_modified Time.now
      # etag "anime/#{params[:id]}/#{options}"

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

      if params.include? 'page' and params[:page].is_a? Integer
        options[:page] = params[:page]
      end

      logger.info "Fetching anime list with options #{options}..."

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "anime/top/#{options[:type]}/#{options[:page]}"

      anime = Railgun::Anime.top(options)

      anime.to_json

    end

    # GET /anime/season
    # Gets a page of a seaonal list of anime.
    # Parameters:
    # - year (optional):   The year, expressed in four digits (i.e. 2006).
    #                      If no value is provided, this defaults to the current year.
    #                      You _must_ provide a seasonif you provide a year.
    # - season (optional): The season, expressed as a string (i.e. 'summer').
    #                      Available options: 'spring', 'summer', 'fall', 'winter'.
    #                      If no value is provided, this defaults to whatever
    #                      MyAnimeList deems as the current season.
    #                      You _must_ provide a year if you provide a season.
    get '/anime/season' do

      options = {}
      # options = {
      #     year: Time.now.year.to_s
      # }

      # if params.include? 'type' and Railgun::MALNetworkService.rank_type_is_acceptable_for_anime_request(params[:type])
      #   options[:year] = params[:type]
      # end
      #
      # if params.include? 'page' and params[:page].is_a? Integer
      #   options[:page] = params[:page]
      # end

      logger.info "Fetching seasonal anime list with options #{options}..."

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "anime/season/#{options[:year]}/#{options[:season]}"

      anime = Railgun::Anime.season(options)

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

      # FIXME: Removing caching on search for now. Figure out how to better cache this
      # expires 3600, :public, :must_revalidate
      # last_modified Time.now
      # etag "manga/#{params[:id]}/#{options}"

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

    # GET /manga/top
    # Gets a page of a ranked list of manga. A page consists of 50 manga.
    # Parameters:
    # - type (optional): The type of list to fetch. Available options:
    #                    'all', 'manga', 'novels', 'oneshots', 'doujinshi', 'manhwa', 'manhua', 'popular', 'favorite'.
    #                    If no type is provided, this defaults to 'all'.
    # - page (optional): The page of manga to fetch. If no value is provided, this defaults to 0.
    #                    Each page consists of 50 manga; fetching page 1 returns manga
    #                    ranked 51-100, page 2 returns 101-150, etc.
    get '/manga/top' do

      options = {
          type: 'all',
          page: 0
      }

      if params.include? 'type' and Railgun::MALNetworkService.rank_type_is_acceptable_for_manga_request(params[:type])
        options[:type] = params[:type]
      end

      if params.include? 'page' and params[:page].is_a? Integer
        options[:page] = params[:page]
      end

      logger.info "Fetching manga list with options #{options}..."

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "manga/top/#{options[:type]}/#{options[:page]}"

      manga = Railgun::Manga.top(options)

      manga.to_json

    end

    #
    # Character Endpoints
    #

    # GET /character/#{character_id}
    # Get details for a character.
    # Parameters:
    # - id: The character's ID.
    get '/character/:id' do
      pass unless params[:id] =~ /^\d+$/

      logger.info "Fetching character with ID #{params[:id]}..."

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "character/#{params[:id]}"

      character = Railgun::Character.scrape(params[:id])

      character.to_json
    end

    #
    # Person Endpoints
    #

    # GET /person/#{person_id}
    # Get details for a person.
    # Parameters:
    # - id: The person's ID.
    get '/person/:id' do
      pass unless params[:id] =~ /^\d+$/

      logger.info "Fetching person with ID #{params[:id]}..."

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "person/#{params[:id]}"

      person = Railgun::Person.scrape(params[:id])

      person.to_json
    end

  end

  namespace '/1.1' do

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

      anime = redis.get "anime:#{params[:id]}"

      if anime.nil?

        logger.info 'Anime was not found in redis, making a request...'
        # FIXME: Removing caching on search for now. Figure out how to better cache this
        # expires 3600, :public, :must_revalidate
        # last_modified Time.now
        # etag "anime/#{params[:id]}/#{options}"

        response = Railgun::Anime.scrape(params[:id], options)

        json = response.to_json

        logger.info 'Storing in redis...'
        redis.setnx "anime:#{params[:id]}", json
        redis.cache(params[:id], 86400) { json }
      else
        logger.info "Cached version of #{params[:id]} found, returning..."
        anime
      end





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

      if params.include? 'page' and params[:page].is_a? Integer
        options[:page] = params[:page]
      end

      logger.info "Fetching anime list with options #{options}..."

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "anime/top/#{options[:type]}/#{options[:page]}"

      anime = Railgun::Anime.top(options)

      anime.to_json

    end

    # GET /anime/season
    # Gets a page of a seaonal list of anime.
    # Parameters:
    # - year (optional):   The year, expressed in four digits (i.e. 2006).
    #                      If no value is provided, this defaults to the current year.
    #                      You _must_ provide a seasonif you provide a year.
    # - season (optional): The season, expressed as a string (i.e. 'summer').
    #                      Available options: 'spring', 'summer', 'fall', 'winter'.
    #                      If no value is provided, this defaults to whatever
    #                      MyAnimeList deems as the current season.
    #                      You _must_ provide a year if you provide a season.
    get '/anime/season' do

      options = {}
      # options = {
      #     year: Time.now.year.to_s
      # }

      # if params.include? 'type' and Railgun::MALNetworkService.rank_type_is_acceptable_for_anime_request(params[:type])
      #   options[:year] = params[:type]
      # end
      #
      # if params.include? 'page' and params[:page].is_a? Integer
      #   options[:page] = params[:page]
      # end

      logger.info "Fetching seasonal anime list with options #{options}..."

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "anime/season/#{options[:year]}/#{options[:season]}"

      anime = Railgun::Anime.season(options)

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

      # FIXME: Removing caching on search for now. Figure out how to better cache this
      # expires 3600, :public, :must_revalidate
      # last_modified Time.now
      # etag "manga/#{params[:id]}/#{options}"

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

    # GET /manga/top
    # Gets a page of a ranked list of manga. A page consists of 50 manga.
    # Parameters:
    # - type (optional): The type of list to fetch. Available options:
    #                    'all', 'manga', 'novels', 'oneshots', 'doujinshi', 'manhwa', 'manhua', 'popular', 'favorite'.
    #                    If no type is provided, this defaults to 'all'.
    # - page (optional): The page of manga to fetch. If no value is provided, this defaults to 0.
    #                    Each page consists of 50 manga; fetching page 1 returns manga
    #                    ranked 51-100, page 2 returns 101-150, etc.
    get '/manga/top' do

      options = {
          type: 'all',
          page: 0
      }

      if params.include? 'type' and Railgun::MALNetworkService.rank_type_is_acceptable_for_manga_request(params[:type])
        options[:type] = params[:type]
      end

      if params.include? 'page' and params[:page].is_a? Integer
        options[:page] = params[:page]
      end

      logger.info "Fetching manga list with options #{options}..."

      expires 3600, :public, :must_revalidate
      last_modified Time.now
      etag "manga/top/#{options[:type]}/#{options[:page]}"

      manga = Railgun::Manga.top(options)

      manga.to_json

    end

    #
    # Character Endpoints
    #

    # GET /character/#{character_id}
    # Get details for a character.
    # Parameters:
    # - id: The character's ID.
    get '/character/:id' do
      pass unless params[:id] =~ /^\d+$/

      logger.info "Fetching character with ID #{params[:id]}..."

      # FIXME: Removing caching on search for now. Figure out how to better cache this
      # expires 3600, :public, :must_revalidate
      # last_modified Time.now
      # etag "character/#{params[:id]}"

      character = Railgun::Character.scrape(params[:id])

      character.to_json
    end

    #
    # Person Endpoints
    #

    # GET /person/#{person_id}
    # Get details for a person.
    # Parameters:
    # - id: The person's ID.
    get '/person/:id' do
      pass unless params[:id] =~ /^\d+$/

      logger.info "Fetching person with ID #{params[:id]}..."

      # FIXME: Removing caching on search for now. Figure out how to better cache this
      # expires 3600, :public, :must_revalidate
      # last_modified Time.now
      # etag "person/#{params[:id]}"

      person = Railgun::Person.scrape(params[:id])

      person.to_json
    end

    #
    # User Endpoints
    #

    # GET /user/#{user_id}/friends
    # Get a list of friends for a user.
    # Parameters:
    # - id: The user's username.
    get '/user/:id/:option' do
      pass unless params[:id] =~ /^\d+$/ || params[:option] =~ /^\w+$/

      if params[:option] == 'friends'
        logger.info "Fetching friends for user with ID #{params[:id]}..."

        expires 3600, :public, :must_revalidate
        last_modified Time.now
        etag "user/#{params[:id]}/friends"

        users = Railgun::User.scrape_friends(params[:id])

        users.to_json
      end

    end

  end

  get '/' do
    content_type 'text/html;charset=utf-8'
    send_file File.expand_path('index.html', settings.public_folder)
  end

end