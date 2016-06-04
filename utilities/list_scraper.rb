require_relative 'url_utilities'

module Railgun

  class ListScraper

    def scrape(nokogiri)
      resources = []

      # Find the table.
      table = nokogiri.xpath('//div[@id="content"]/div/table')
      table.xpath('//tr[@class="ranking-list"]').each do |tr|
        resources << parse_row(tr)
      end

      resources
    end

    def parse_row(nokogiri)
      # TO BE OVERRIDDEN BY SUBCLASSES
    end

    def parse_id(entity, url)
      UrlUtilities::parse_id_from_url(entity, url)
    end

    def parse_name(nokogiri)
      name_element = nokogiri.at('td[2] div[@class="detail"] div a')
      name_element.text.strip
    end

    def parse_url(nokogiri)
      url_element = nokogiri.at('td[2] div[@class="detail"] div a')
      url_element['href']
    end

    def parse_image_url(entity, nokogiri)
      image_element = nokogiri.at('td[2] a img')
      image_url = image_element['data-src']

      # MAL returns a tiny image for the thumbnail.
      # In order to get the full-sized image, we must construct our own url.

      UrlUtilities::create_original_image_url(entity, image_url)
    end

    def parse_type(nokogiri)
      type_element = parse_metadata(nokogiri).first
      $1 if type_element.match %r{([a-zA-Z]+) \([0-9]+ eps\)}
    end

    def parse_episodes(nokogiri)
      type_element = parse_metadata(nokogiri).first
      $1.to_i if type_element.match %r{[a-zA-Z]+ \(([0-9]+) eps\)}
    end

    def parse_start_date(nokogiri)
      date = parse_dates(nokogiri).first
      BaseScraper::parse_start_date(date)
    end

    def parse_end_date(nokogiri)
      date = parse_dates(nokogiri).last
      BaseScraper::parse_end_date(date)
    end

    def parse_member_count(nokogiri)
      # Strip out commas in the number to make regex easier.
      member_count_element = parse_metadata(nokogiri).last.strip.gsub(',', '')
      $1.to_i if member_count_element.match %r{([0-9]+) members}
    end

    def parse_rank(nokogiri)
      rank_element = nokogiri.at('td[1] span')
      rank_element.text.to_i
    end

    # Convenience Methods

    def parse_metadata(nokogiri)
      metadata_element = nokogiri.at('td[2] div[@class="detail"] div[4]')
      metadata_element.text.strip.split(%r{\n}).map { |element| element.strip }
    end

    def parse_dates(nokogiri)
      parse_metadata(nokogiri)[1].split('-').map { |date| date.strip }
    end

  end

end