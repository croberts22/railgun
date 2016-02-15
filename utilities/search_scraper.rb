module Railgun

  class SearchScraper

    def scrape(nokogiri)
      # Find the table.
      table = nokogiri.xpath('//div[@id="content"]/table')
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

  end


end