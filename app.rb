require 'sinatra'
require './railgun'

class App < Sinatra::Base

  # GET /#{VERSION}/anime/#{anime_id}
  # Gets details for an anime.
  get '/:v/anime/:id' do
    pass unless params[:id] =~ /^\d+$/

    options = nil

    if params.include? 'options'
      options = params[:options].split(',')
    end

    anime = Railgun::Anime.scrape(params[:id], options)

    anime.to_json

  end

end