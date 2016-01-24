require 'sinatra'
require_relative 'railgun'

class App < Sinatra::Base

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

    anime = Railgun::Anime.scrape(params[:id], options)

    anime.to_json
  end



end