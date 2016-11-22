module Railgun

  class Endpoints

    attr_reader :myanimelist_host, :myanimelist_cdn_host

    def self.myanimelist_host
      @myanimelist_host = 'https://myanimelist.net'
    end

    def self.myanimelist_cdn_host
      @myanimelist_cdn_host = 'https://myanimelist.cdn-dena.com'
    end

  end

end
