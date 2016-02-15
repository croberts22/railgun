require 'sinatra'
require_relative 'railgun'

class App < Sinatra::Base

  before do
    content_type 'application/json'
  end

  # GET /#{VERSION}/anime/#{anime_id}
  # Get an anime's details.
  # Parameters:
  # - id: The anime's ID.
  # - options (optional): A comma-separated list of strings that define additional stats.
  #                       Available options include 'stats' and 'characters_and_staff'.
  get '/:v/anime/:id' do
    pass unless params[:id] =~ /^\d+$/

    options = []

    if params.include? 'options'
      options = params[:options].split(',')
    end

    expires 3600, :public, :must_revalidate
    last_modified Time.now
    etag "anime/#{params[:id]}/#{options}"

    anime = Railgun::Anime.scrape(params[:id], options)

    anime.to_json
  end

  # GET /#{VERSION}/manga/#{manga_id}
  # Get a manga's details.
  # Parameters:
  # - id: The manga's ID.
  # - options (optional): A comma-separated list of strings that define additional stats.
  #                       Available options include 'stats' and 'characters_and_staff'.
  get '/:v/manga/:id' do
    pass unless params[:id] =~ /^\d+$/

    options = []

    if params.include? 'options'
      options = params[:options].split(',')
    end

    expires 3600, :public, :must_revalidate
    last_modified Time.now
    etag "manga/#{params[:id]}/#{options}"

    manga = Railgun::Manga.scrape(params[:id], options)

    manga.to_json
  end

  get '/:v/search/?q=:q' do

  end

end