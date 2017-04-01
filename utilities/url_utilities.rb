require_relative 'endpoints'

module Railgun

  class UrlUtilities

    def self.original_image_from_element(entity, element)
      if image_url = image_url_from_element(element)
        create_original_image_url(entity, image_url)
      end
    end

    def self.image_url_from_element(element)
      element.attribute('src') ?
          element.attribute('src').to_s :
          element.attribute('data-src') ? element.attribute('data-src').to_s : nil
    end

    def self.create_original_image_url(entity, url)
      # http://cdn.myanimelist.net/r/50x71/images/anime/2/73842.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce
      # http://cdn.myanimelist.net        /images/anime/2/73842.jpg

      image_url = url
      base_url = Endpoints.myanimelist_cdn_host

      url_match = url.match("/images/#{entity}/.+.jpg")
      if url_match
        image_url = base_url + url_match[0]
      end

      # If the last letter of the file is 't' or 'v', remove it. This returns a
      # tiny image.
      image_url = image_url.gsub('t.jpg', '.jpg')
      image_url = image_url.gsub('v.jpg', '.jpg')

      # We can sometimes be stuck inside a 'thumbs/' directory, or the name might
      # end in '_thumb.jpg'. Sub these out.
      image_url = image_url.gsub('thumbs/', '')
      image_url = image_url.gsub('_thumb.jpg', '.jpg')

      image_url
    end

    def self.parse_id_from_url(entity, url)

      id_match = url.match("/#{entity}/(\\d+)/.*")

      id_match[1]
    end

  end

end