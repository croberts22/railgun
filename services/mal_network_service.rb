require 'curl'
require_relative 'keys'
require_relative '../utilities/endpoints'
require_relative '../utilities/redirectable_nokogiri'

module Railgun

  class MALNetworkService

    def self.myanimelist_host
      Endpoints.myanimelist_host
    end

    # Generates a simple Curl object, bundled with a User-Agent.
    # returns a Curl object.
    def self.create_request(url)

      # Before we make a request, check to make sure the host exists.
      if (url.include? self.myanimelist_host) == false
        puts "url #{url} does not include the host, adding that now..."
        url = myanimelist_host + url
      end

      curl = Curl::Easy.new(url)
      curl.headers['User-Agent'] = Keys.myanimelist_api_key

      curl
    end

    def self.nokogiri_from_request(url)

      curl = create_request(url)

      begin
        curl.perform
      rescue Exception => e
        raise Railgun::NetworkError.new("An error occurred while performing #{url}. \n\n Original exception: #{e.message}.", e)
      end

      response = curl.body_str

      # Check if the resource does not exist.
      raise Railgun::NotFoundError.new("Resource at url #{url} doesn't exist.", nil) if response =~ /This page doesn't exist./i

      doc = Nokogiri::HTML(response)

      doc
    end


    def self.nokogiri_from_redirectable_request(url)

      begin
        response = Net::HTTP.start('myanimelist.net', 80) do |http|
          http.get(url, { 'User-Agent' => Keys.myanimelist_api_key })
        end

        case response
          when Net::HTTPRedirection
            redirected = true

            # Strip everything after the anime ID - in cases where there is a non-ASCII character in the URL,
            # MyAnimeList.net will return a page that says "Access has been restricted for this account".
            redirect_url = response['location'].sub(%r{(http[s]?://myanimelist.net/.*/\d+)/?.*}, '\2')

            response = Net::HTTP.start('myanimelist.net', 80) do |http|
              http.get(redirect_url, { 'User-Agent' => Keys.myanimelist_api_key })
            end
        end

      rescue Exception => e
        raise Railgun::NetworkError.new("Error searching anime with query '#{query}'. Original exception: #{e.message}", e)
      end

      nokogiri = Nokogiri::HTML(response.body)

      doc = Railgun::RedirectableNokogiri.new
      doc.nokogiri = nokogiri
      doc.redirected = redirected

      doc
    end

    ### Convenience Methods

    def self.anime_request_for_id(id)
      "https://myanimelist.net/anime/#{id}"
    end

    def self.anime_search_request_with_query(query)
      "https://myanimelist.net/anime.php?q=#{query}"
    end

    def self.manga_request_for_id(id)
      "https://myanimelist.net/manga/#{id}"
    end

    def self.manga_search_request_with_query(query)
      "https://myanimelist.net/manga.php?q=#{query}"
    end

    def self.anime_rank_request(type, page)
      request = 'https://myanimelist.net/topanime.php'
      if rank_type_is_acceptable_for_anime_request(type)
        request += "?type=#{type}"
      else
        request += '?type=all'
      end

      request += "&page=#{page}" if page && (page.is_a? Integer)

      request
    end


    ### Parameter Checking Methods

    def self.rank_type_is_acceptable_for_anime_request(type)
      accepted_types = %w(all airing upcoming tv movie ova special popular favorite)

      acceptable_type = false
      acceptable_type = true if type and accepted_types.include? type

      acceptable_type
    end

  end

end