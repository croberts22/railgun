require 'chronic'

module Railgun

  class BaseScraper

    # Date Parsing.

    def self.parse_start_date(text)
      text = text.strip

      case text
        when /^\d{4}$/
          return text.strip
        when /^(\d{4}) to \?/
          return $1
        when /^\d{2}-\d{2}-\d{2}$/
          return Date.strptime(text, '%m-%d-%y')
        else
          date_string = text.split(/\s+to\s+/).first
          return nil if !date_string

          Chronic.parse(date_string, guess: :begin)
      end
    end

    def self.parse_end_date(text)
      text = text.strip

      case text
        when /^\d{4}$/
          return text.strip
        when /^\? to (\d{4})/
          return $1
        when /^\d{2}-\d{2}-\d{2}$/
          return Date.strptime(text, '%m-%d-%y')
        else
          date_string = text.split(/\s+to\s+/).last
          return nil if !date_string

          Chronic.parse(date_string, guess: :begin)
      end
    end


    # Character and Voice Actor parsing.
    # FIXME: Ripped from umalapi. This does not currently include staff parsing. Very fragile code, this should be revisited.
    def parse_staff(nokogiri)

      character_voice_actors = []

      nokogiri.search('table').each do |table|

        td_nodes = table.xpath('tr/td')

        # If the node size is not 3, then we know this is probably pointing to the staff
        # table at the bottom. Just ignore, since we require 3 td rows.
        if td_nodes.size != 3 then
          next
        end

        counter = 0

        character_details = {}
        voice_actor_details = []

        td_nodes.each { |td|
          # puts 'Node: ' + td.to_s + '\n'

          # Character URL and Image URL.
          if counter == 0
            character_url = td.at('a/@href').to_s
            image_url = td.at('img/@src').to_s
            image_url = 'http://cdn.myanimelist.net' + image_url.match(%r{/images/characters/.*.jpg}).to_s

            id = character_url[%r{/character/(\d+)/.*?}, 1].to_s

            # puts 'Character URL: ' + character_url
            # puts 'Image URL: ' + image_url

            character_details[:name] = ''
            character_details[:id] = id
            character_details[:url] = character_url
            character_details[:role] = ''
            character_details[:image_url] = image_url
          end

          # Name of Character
          if counter == 1
            character_name = td.at('a/text()').to_s
            character_role = td.xpath('div/small/text()').to_s

            # puts 'Character name: ' + character_name

            character_details[:name] = character_name
            character_details[:role] = character_role
          end

          # Voice actors for this character (embedded in its own table)
          if counter == 2
            inner_table_tr_nodes = td.xpath('table/tr')
            inner_table_tr_nodes.each { |inner_tr|
              # puts 'inner_tr' + inner_tr.to_s
              # Actor's name and Language
              actor_name = inner_tr.at('td[1]/a/text()').to_s
              actor_name_url = inner_tr.at('td[1]/a/@href').to_s
              actor_language = inner_tr.at('td[1]/small/text()').to_s
              id = actor_name_url[%r{/people/(\d+)/.*?}, 1].to_s

              # Actor's image URL
              actor_image_url = inner_tr.xpath('td[2]').at('div/a/img/@src').to_s
              actor_image_url = 'http://cdn.myanimelist.net' + actor_image_url.match(%r{/images/voiceactors/.*.jpg}).to_s

              if actor_name.length > 0
                voice_actor_details << {
                    :name => actor_name,
                    :id => id,
                    :url => actor_name_url,
                    :language => actor_language,
                    :image_url => actor_image_url
                }
              end
            }

            character_voice_actors << { :character => character_details, :voice_actor => voice_actor_details }

          end

          counter += 1
        }

      end

      character_voice_actors
    end
  end

end