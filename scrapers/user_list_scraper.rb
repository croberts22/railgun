require_relative '../scrapers/list_scraper'
require_relative '../utilities/date_formatter'

module Railgun

  class UserListScraper < ListScraper

    def scrape(nokogiri)
      users = []

      # Find the table.
      nodes = nokogiri.at('//div[@class="majorPad"]').children.select do |div|
        div['class'] == 'friendHolder'
      end

      nodes.each do |div|
        users << parse_row(div)
      end

      users
    end

    def parse_row(nokogiri)

      id = parse_id(nokogiri)
      name = parse_name(nokogiri)
      url = parse_url(nokogiri)
      image_url = parse_image_url(nokogiri)

      {
          id: id,
          name: name,
          url: url,
          image_url: image_url
      }

    end

    def parse_id(nokogiri)
      url = nokogiri.at('div div a')['href']
      UrlUtilities::parse_username_from_url(url)
    end

    def parse_name(nokogiri)
      nokogiri.at('div div[2] a strong').text.strip
    end

    def parse_url(nokogiri)
      nokogiri.at('div div a')['href']
    end

    def parse_image_url(nokogiri)
      image_element = nokogiri.at('div div a img')
      UrlUtilities::original_image_from_element('userimages', image_element)
    end

  end

end