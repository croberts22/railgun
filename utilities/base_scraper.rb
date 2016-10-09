require 'chronic'

module Railgun

  class BaseScraper

    # Details Parsing.

    def parse_title(nokogiri)
      nokogiri.at('h1 span').text
    end

    def parse_rank(nokogiri)
      nokogiri.at('div[@id="contentWrapper"] > div > table > tr > td > div > div > span:contains("Ranked:")').next.text.gsub(/\D/, '').to_i
    end

    def parse_image_url(nokogiri)
      if image_node = nokogiri.at('div#content tr td div img')
        image_node['data-src'] || image_node['src']
      end
    end

    def parse_alternative_titles(nokogiri)
      other_titles = {}

      if (node = nokogiri.at('//span[text()="English:"]')) && node.next
        other_titles[:english] = node.next.text.strip.split(/,\s?/)
      end
      if (node = nokogiri.at('//span[text()="Synonyms:"]')) && node.next
        other_titles[:synonyms] = node.next.text.strip.split(/,\s?/)
      end
      if (node = nokogiri.at('//span[text()="Japanese:"]')) && node.next
        other_titles[:japanese] = node.next.text.strip.split(/,\s?/)
      end

      other_titles
    end

    def parse_synopsis(nokogiri)
      synopsis_h2 = nokogiri.at('//h2[text()="Synopsis"]')
      synopsis = ''

      if synopsis_h2
        node = synopsis_h2.next

        while node

          if node.name.eql? 'h2'
            node = nil
            next
          end

          # Replace occurrences of br with escaped newlines.
          if node.to_s.eql? '<br>' or node.to_s.eql? '<br />'
            synopsis << "\\n"
          else
            synopsis << '' << Nokogiri::HTML(node.to_s).xpath('//text()').map(&:text).join('')
          end

          node = node.next

        end
      end

      synopsis
    end

    def parse_type(nokogiri)
      if (node = nokogiri.at('//span[text()="Type:"]')) && node.next.next
        type = node.next.next.text.strip

        type
      end
    end

    def parse_status(nokogiri)
      if (node = nokogiri.at('//span[text()="Status:"]')) && node.next
        status = node.next.text.strip

        status
      end
    end

    def parse_genres(nokogiri)
      genres = []

      if node = nokogiri.at('//span[text()="Genres:"]')
        node.parent.search('a').each do |a|
          genres << a.text.strip
        end

        genres
      end
    end

    def parse_score(nokogiri)
      if (node = nokogiri.at('//span[@itemprop="ratingValue"]'))
        members_score = node.text.strip.to_f

        members_score
      end
    end

    def parse_popularity_rank(nokogiri)
      if (node = nokogiri.at('//span[text()="Popularity:"]')) && node.next
        popularity_rank = node.next.text.strip.sub('#', '').gsub(',', '').to_i

        popularity_rank
      end
    end

    def parse_member_count(nokogiri)
      if (node = nokogiri.at('//span[text()="Members:"]')) && node.next
        member_count = node.next.text.strip.gsub(',', '').to_i

        member_count
      end
    end

    def parse_favorite_count(nokogiri)
      if (node = nokogiri.at('//span[text()="Favorites:"]')) && node.next
        favorite_count = node.next.text.strip.gsub(',', '').to_i

        favorite_count
      end
    end

    def parse_tags(nokogiri)
      tags = []

      if (node = nokogiri.at('//span[preceding-sibling::h2[text()="Popular Tags"]]'))
        node.search('a').each do |a|
          tags << a.text
        end
      end

      tags
    end

    def parse_additional_info_urls(nokogiri)
      additional_info_urls = {}

      if (node = nokogiri.at('//div[@id="horiznav_nav"]/ul'))
        urls = node.search('li')

        (0..urls.length-1).each { |i|
          url_node = urls[i]

          additional_url_title = url_node.at('//div[@id="horiznav_nav"]/ul/li['+(i+1).to_s+']/a[1]/text()')
          additional_url = url_node.at('//div[@id="horiznav_nav"]/ul/li['+(i+1).to_s+']/a[1]/@href')

          if (additional_url_title.to_s == 'Details')
            additional_info_urls[:details] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Reviews')
            additional_info_urls[:reviews] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Recommendations')
            additional_info_urls[:recommendations] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Stats')
            additional_info_urls[:stats] = additional_url.to_s
          end
          if (additional_url_title.to_s.include? 'Characters')
            additional_info_urls[:characters_and_staff] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'News')
            additional_info_urls[:news] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Forum')
            additional_info_urls[:forum] = additional_url.to_s
          end
          if (additional_url_title.to_s == 'Pictures')
            additional_info_urls[:pictures] = additional_url.to_s
          end
        }
      end

      additional_info_urls
    end

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
            image_url = td.at('img/@data-src').to_s || td.at('img/@src').to_s
            image_url = 'https://myanimelist.cdn-dena.com' + image_url.match(%r{/images/characters/.*.jpg}).to_s

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
              actor_image_url = inner_tr.xpath('td[2]').at('div/a/img/@data-src').to_s || inner_tr.xpath('td[2]').at('div/a/img/@src').to_s
              actor_image_url = 'https://myanimelist.cdn-dena.com' + actor_image_url.match(%r{/images/voiceactors/.*.jpg}).to_s

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


    def parse_reviews(nokogiri)

      reviews = []

      # TODO: maybe?
      review_div = nokogiri.at('//div[contains(@class, "borderDark")]')

      while review_div

        review = Review.new

        # Reviewer.
        # td[1] = Profile picture, url
        # td[2] = Reviewer name, metadata
        # td[3] = Additional metadata
        reviewer_table = review_div.at('div > table > tr')
        break unless !reviewer_table.nil?

        # Odd that there is an embedded div with the same class ("picSurround").
        # May not need to check for this if we explicitly request td[0].
        reviewer_profile = reviewer_table.at('td[1] div div[@class="picSurround"]')
        review.user_url = reviewer_profile.at('a')['href']

        # FIXME: Can strip /thumbs/ and _thumb at the end of the url to get a full-size resolution image.
        review.user_image_url = reviewer_profile.at('a img')['data-src']
        review.username = reviewer_table.at('td[2] a').text

        # Review Metadata (number of users who found the review helpful)
        # TODO: Rename these variables to something a little more sensible.
        review.helpful_review_count = reviewer_table.at('td[2] strong').parent.text.scan(/\d+/).first

        # TODO: For now, bypassing "Other reviews from this user" for a later update.
        review_metadata_td = reviewer_table.at('td[3]')

        review.date = review_metadata_td.at('div[1]').text

        review_episodes_text = review_metadata_td.at('div[2]').text
        review.episodes_watched = review_episodes_text.scan(/\d+/).first
        review.episodes_total = review_episodes_text.scan(/\d+/).last

        # Split between : in "Overall Rating: 7", take the last, and strip spaces on the edges.
        # review.rating = review_metadata_td.at('div[3]').text.split(/:/).last.strip

        # Score Breakdown.
        score_table = review_div.at('div[@class="spaceit textReadability word-break"] > div > table')
        score_table.search('tr').each do |tr|
          # td[0]: Category
          category = tr.child.text.downcase

          # td[1]: Score
          score = tr.child.next.text

          review.rating[category] = score

        end

        # Review.
        user_review_div = review_div.at('div[@class="spaceit textReadability word-break"] > div').next
        review_text = ''

        while user_review_div

          # Treat <br> as newlines in the response.
          if user_review_div.to_s.eql? '<br>'
            review_text << '\n'
          end

          # Do not include the last part of the div, which includes a 'read more' button.
          review_text << user_review_div.text unless user_review_div.to_s.include? 'read more'

          # Move on to the next element.
          user_review_div = user_review_div.next
        end

        review.review = review_text

        reviews << review
        review_div = review_div.next
      end

      reviews
    end

    def parse_recommendations(nokogiri)

    end

  end

end