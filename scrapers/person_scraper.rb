require_relative '../scrapers/scraper'
require_relative '../utilities/date_formatter'

module Railgun

  class PersonScraper < Scraper

    def scrape(nokogiri, person)

      person.id = parse_id(nokogiri)
      person.name = parse_name(nokogiri)
      person.url = parse_url(nokogiri)
      person.image_url = parse_image_url(nokogiri)
      person.given_name = parse_given_name(nokogiri)
      person.family_name = parse_family_name(nokogiri)
      person.alternate_names = parse_alternate_names(nokogiri)
      person.birthday = parse_birthday(nokogiri)
      person.website = parse_website(nokogiri)
      person.favorited_count = parse_favorite_count(nokogiri)
      person.more_info = parse_more_info(nokogiri)
      person.voice_acting_roles = parse_voice_acting_roles(nokogiri)
      person.anime_staff_positions = parse_anime_staff_positions(nokogiri)
      person.published_manga = parse_published_manga(nokogiri)

      person
    end

    def parse_id(nokogiri)
      id = nil

      metadata_url = nokogiri.at('meta[@property="og:url"]').attribute('content').to_s
      if metadata_url
        id = metadata_url[%r{http[s]?://myanimelist.net/[a-zA-Z]+/(\d+)/.*?}, 1]
      end

      id
    end

    def parse_name(nokogiri)
      nokogiri.at('h1').text
    end

    def parse_url(nokogiri)
      nokogiri.at('meta[@property="og:url"]').attribute('content').to_s
    end

    def parse_image_url(nokogiri)
      nokogiri.at('div#content tr td div img').attribute('src').to_s
    end

    def parse_given_name(nokogiri)
      element = nokogiri.at('span[text()="Given name:"]')
      if element and element = element.next
        element.text.strip
      end
    end

    def parse_family_name(nokogiri)
      element = nokogiri.at('span[text()="Family name:"]')
      if element and element = element.next
        element.text.strip
      end
    end

    def parse_alternate_names(nokogiri)
      element = nokogiri.at('span[text()="Alternate names:"]')
      if element and element = element.next
        names = []

        element.text.split(',').each do |element|
          names << element.strip
        end

        names
      end
    end

    def parse_birthday(nokogiri)
      element = nokogiri.at('span[text()="Birthday:"]')
      if element and element = element.next
        formatter = Railgun::DateFormatter.new
        formatter.date_from_string(element.text.strip)
      end
    end

    def parse_website(nokogiri)
      element = nokogiri.at('span[text()="Website:"]')
      if element and element = element.next
        element.next.attribute('href').to_s
      end
    end

    def parse_favorite_count(nokogiri)
      element = nokogiri.at('span[text()="Member Favorites:"]')
      if element and element = element.next
        element.text.gsub(',', '').to_i
      end
    end

    def parse_more_info(nokogiri)
      element = nokogiri.at('span[text()="More:"]')
      if element and element = element.parent.next
        more_info = ''

        element.children.each do |line|
          # Sub literal "\n" in strings for \n.
          more_info << line.text.gsub("\r\n", "\n")
        end

        more_info
      end
    end

    def parse_voice_acting_roles(nokogiri)

      voice_acting_roles = []

      if header = nokogiri.at('div[text()="Voice Acting Roles"]').next

        if table_node = header

          table_node.children.each do |tr|

            next unless tr.is_a?(Nokogiri::XML::Element)


            # Anime
            # td[1] -> Poster
            # td[2] -> Name, URL

            # Character
            # td[3] -> Name, URL, Role
            # td[4] -> Poster

            image_url = UrlUtilities.original_image_from_element('anime', tr.at('td[1] div img'))
            url = tr.at('td[1] div a').attribute('href').to_s
            id = UrlUtilities.parse_id_from_url('anime', url)
            name = tr.at('td[2] a').text

            character_image_url = UrlUtilities.original_image_from_element('characters', tr.at('td[4] div a img'))
            character_url = tr.at('td[3] a').attribute('href').to_s
            character_id = UrlUtilities.parse_id_from_url('character', character_url)
            character_name = tr.at('td[3] a').text

            # Unfortunately, sometimes an &nbsp; tag is pushed in there. Running this through
            # .text makes it unavailable to parse out via gsub, so we need to explicitly cast it
            # to a string and parse the literal substring out.
            role = tr.at('td[3] div//text()').to_s.gsub(/(&nbsp;|\s)+/, '')

            voice_acting_roles << {
                anime: {
                    id: id,
                    name: name,
                    url: url,
                    image_url: image_url,
                },
                character: {
                    id: character_id,
                    name: character_name,
                    url: character_url,
                    image_url: character_image_url,
                    role: role
                }
            }

          end

        end

      end

      voice_acting_roles
    end

    def parse_anime_staff_positions(nokogiri)

    end

    def parse_published_manga(nokogiri)

    end

  end

end