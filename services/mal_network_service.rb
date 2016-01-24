require 'curl'
require_relative 'keys'

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

  end

end