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
        raise Railgun::NetworkError.new("An error occurred while performing ${url}. \n\n Original exception: #{e.message}.", e)
      end

      response = curl.body_str

      doc = Nokogiri::HTML(response)

      doc

    end

  end

end