require_relative '../scrapers/seasonal_scraper'
require_relative '../utilities/url_utilities'

module Railgun

  class AnimeSeasonalScraper < SeasonalScraper

    def scrape(nokogiri)

      anime = []

      # Scrape New TV series.
      tv_header = nokogiri.at('div[text()="TV (New)"]')
      if children_nodes = tv_header.parent.children

        children_nodes.each do |c|

          next unless c.attribute('class').to_s.include? 'seasonal-anime'

          name = c.at('div div[@class="title"] p a').text
          url = c.at('div div[@class="title"] p a').attribute('href').to_s
          id = UrlUtilities.parse_id_from_url('anime', url)
          image_url = UrlUtilities.original_image_from_element('anime', c.at('div[@class="image"] img'))

          anime << {
              id: id,
              name: name,
              url: url,
              image_url: image_url
          }

        end

      end

      anime
    end

    def parse_item(nokogiri)

    end

  end

end
