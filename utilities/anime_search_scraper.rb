require_relative 'search_scraper'

module Railgun

  class AnimeSearchScraper < SearchScraper

    def parse_row(nokogiri)

      url = nokogiri.parent['href']
      return unless url.match %r{http://myanimelist.net/anime/(\d+)/?.*}

      anime = Anime.new

      anime.id = $1.to_i
      anime.title = nokogiri.text
      if image_node = results_row.at('td a img')
        anime.image_url = image_node['src']
      end

      table_cell_nodes = results_row.search('td')

      anime.episodes = table_cell_nodes[3].text.to_i
      anime.members_score = table_cell_nodes[4].text.to_f
      synopsis_node = results_row.at('div.spaceit')
      if synopsis_node
        synopsis_node.search('a').remove
        anime.synopsis = synopsis_node.text.strip
      end
      anime.type = table_cell_nodes[2].text
      anime.start_date = parse_start_date(table_cell_nodes[5].text)
      anime.end_date = parse_end_date(table_cell_nodes[6].text)
      anime.classification = table_cell_nodes[8].text if table_cell_nodes[8]
    end

  end

end