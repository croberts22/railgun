require_relative 'person_scraper'
require_relative '../utilities/url_utilities'

module Railgun

  class CharacterScraper < PersonScraper

    def scrape(nokogiri, character)

      character.id = parse_id(nokogiri)
      character.name = parse_name(nokogiri)
      character.url = parse_url(nokogiri)
      character.image_url = parse_image_url(nokogiri)
      character.nickname = parse_nickname(nokogiri)
      character.anime = parse_animeography(nokogiri)
      character.manga = parse_mangaography(nokogiri)
      character.biography = parse_biography(nokogiri)
      character.actors = parse_voice_actors(nokogiri)
      character.favorited_count = parse_favorite_count(nokogiri)

      character
    end

    def parse_name(nokogiri)
      name_header_node = nokogiri.at('div[@id="content"] table td[2] div[@class="normal_header"]')

      # We could have underlying span text after the name.
      # Get the children nodes, take the first one and remove excess whitespace.
      name_header_node.children.first.text.strip
    end

    def parse_nickname(nokogiri)
      nokogiri.at('h1').text[%r{"(.+)"}, 1]
    end

    def parse_animeography(nokogiri)
      parse_appearances('anime', nokogiri)
    end

    def parse_mangaography(nokogiri)
      parse_appearances('manga', nokogiri)
    end

    def parse_appearances(entity, nokogiri)

      entities = []

      header_title = entity.capitalize + 'ography'

      if header = nokogiri.at("div[text()='#{header_title}']").next

        if table_node = header.next

          table_node.children.each do |tr|

            next unless tr.is_a?(Nokogiri::XML::Element)

            # td[1] -> Poster
            # td[2] -> Name, URL

            image_url = UrlUtilities.create_original_image_url(entity, tr.at('td[1] div img').attribute('src').to_s)
            url = tr.at('td[1] div a').attribute('href').to_s
            id = UrlUtilities.parse_id_from_url(entity, url)

            name = tr.at('td[2] a').text

            role = tr.at('small').text

            entities << {
                id: id,
                name: name,
                url: url,
                image_url: image_url,
                role: role
            }

          end

        end

      end

      entities
    end

    def parse_biography(nokogiri)

      biography = ''

      biography_node = nokogiri.at('div[@id="content"] table td[2] div[@class="normal_header"]')
      if biography_node

        while biography_node = biography_node.next do

          # Once we hit another header, stop parsing.
          break if div_class = biography_node['class'] and div_class == 'normal_header'

          text = biography_node.text.strip

          # Filter out any unnecessary whitespace, if needed.
          text = text.gsub(/\t/, ' ')
          text = text.gsub(/<br( \/)?>/, '')

          #puts text

          biography << text + "\n"
        end

        biography = biography.gsub("\n\n", "\n").strip

      end

      biography
    end

    def parse_voice_actors(nokogiri)

      actors = []

      if children = nokogiri.at('div[text()="Voice Actors"]').parent.children

        children.each do |element|

          # Voice Actors are within their own table. Search for these and parse appropriately.
          next unless element.name == 'table'

          # td[1] -> Poster
          # td[2] -> Name, URL

          image_url = UrlUtilities.create_original_image_url('voiceactors', element.at('td[1] div img').attribute('src').to_s)
          url = element.at('td[1] div a').attribute('href').to_s
          id = UrlUtilities.parse_id_from_url('people', url)

          name = element.at('td[2] a').text

          language = element.at('small').text

          actors << {
              id: id,
              name: name,
              url: url,
              image_url: image_url,
              language: language
          }

        end

      end

      actors
    end


    def parse_favorite_count(nokogiri)
      count = 0

      biography_node = nokogiri.at('div[text()="Animeography"]').next
      if biography_node.next

        # We only care about looking for text that contains "Member Favorites:".
        while biography_node = biography_node.next do

          next unless biography_node.text.include? 'Favorites:'

          # Remove commas before parsing out the number.
          count = biography_node.text.gsub(',', '')[%r{(\d+)}, 1].to_i

        end

      end

      count
    end

  end

end