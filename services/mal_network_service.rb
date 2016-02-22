require 'curl'
require_relative 'keys'
require_relative '../utilities/redirectable_nokogiri'

module Railgun

  class MALNetworkService

    def self.nokogiri_from_request(url)

      curl = Curl::Easy.new(url)
      curl.headers['User-Agent'] = Keys.myanimelist_api_key

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
            redirect_url = response['location'].sub(%r{(http://myanimelist.net/.*/\d+)/?.*}, '\2')

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
      "http://myanimelist.net/anime/#{id}"
    end

    def self.anime_search_request_with_query(query)
      "http://myanimelist.net/anime.php?q=#{query}"
    end

    def self.manga_request_for_id(query)
      "http://myanimelist.net/manga/#{id}"
    end

    def self.manga_search_request_with_query(query)
      "http://myanimelist.net/manga.php?q=#{query}"
    end

  end

end