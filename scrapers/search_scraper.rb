require_relative '../utilities/url_utilities'
require_relative '../scrapers/scraper'

module Railgun

  class SearchScraper < Scraper

    def scrape(nokogiri)
      resources = []

      # Find the table.
      table = nokogiri.xpath('//div[@id="content"]/div/table')
      table.xpath('//tr').each do |tr|

        td = tr.at('td a strong')
        next unless td

        resources << parse_row(tr)
      end

      resources
    end

    def parse_row(nokogiri)
      # TO BE OVERRIDDEN BY SUBCLASSES
    end

    def parse_image_url(entity, nokogiri)
      image_element = nokogiri.at('td[1] div a img')
      image_url = image_element['data-src'] || image_element['src']

      # MAL returns a tiny image for the thumbnail.
      # In order to get the full-sized image, we must construct our own url.

      UrlUtilities::create_original_image_url(entity, image_url)
    end

    def parse_name(nokogiri)
      name_element = nokogiri.at('td[2] a strong')
      name_element.text
    end

    def parse_url(nokogiri)
      url_element = nokogiri.at('td[2] a')
      url_element['href']
    end

    def parse_id(entity, url)
      UrlUtilities::parse_id_from_url(entity, url)
    end

    def parse_type(nokogiri)
      type = nokogiri.at('td[3]')
      type.text.strip
    end

    def parse_quantity(nokogiri)
      quantity = nokogiri.at('td[4]')
      quantity.text.to_i
    end

    def parse_synopsis(nokogiri)
      synopsis_element = nokogiri.at('td div[class="pt4"]')
      synopsis_element.text.gsub('read more.', '').strip
    end

    def parse_score(nokogiri)
      if score_element = nokogiri.at('td[5]')
        score_element.text.to_f
      end
    end

  end

end