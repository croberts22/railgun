module Railgun

  # Barebones class of a scraper. Each scraper should subclass this, as the
  # scraper must understand what it _can_ scrape.
  class Scraper

    attr_accessor :api_version

    def initialize(api_version = API_VERSION)
      @api_version = api_version
    end


  end

end