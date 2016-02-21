require_relative 'search_scraper'

module Railgun

  class AnimeSearchScraper < SearchScraper

    def parse_row(nokogiri)

      # There are five objects per row, with data in the following order:
      # 1: Image
      # 2: Title, Synopsis
      # 3: Type
      # 4: Number of episodes
      # 5: Average Score

      image_element = nokogiri.at('td[1] div a img')
      image_url = image_element['src']

      # In order to get the full-sized image, we must construct our own url.

      # http://cdn.myanimelist.net/r/50x71/images/anime/2/73842.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce
      # http://cdn.myanimelist.net        /images/anime/2/73842.jpg

      base_url = 'http://cdn.myanimelist.net'

      url_match = image_url.match(%r{\/images\/anime\/.+.jpg\\?})
      if url_match
        image_url = base_url + url_match[0]
      end

      name_element = nokogiri.at('td[2] a strong')
      name = name_element.text

      url_element = nokogiri.at('td[2] a')
      url = url_element['href']

      id_match = url.match(%r{/anime/(\d+)/.*?})
      id = id_match[1]

      synopsis_element = nokogiri.at('td[2] div[class="spaceit"]')
      synopsis = synopsis_element.text.gsub('read more.', '').strip

      {
          id: id,
          name: name,
          url: url,
          image_url: image_url,
          synopsis: synopsis
      }
    end

  end

end