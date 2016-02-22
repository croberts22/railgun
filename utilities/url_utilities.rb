module Railgun

  class UrlUtilities

    def self.create_original_image_url(entity, url)
      # http://cdn.myanimelist.net/r/50x71/images/anime/2/73842.jpg?s=7e12d07508f8bc6c9f896fdec7e064ce
      # http://cdn.myanimelist.net        /images/anime/2/73842.jpg

      image_url = url
      base_url = 'http://cdn.myanimelist.net'

      url_match = url.match("/images/#{entity}/.+.jpg")
      if url_match
        image_url = base_url + url_match[0]
      end

      # If the last letter of the file is 't', remove it. This returns a
      # tiny image.
      image_url = image_url.gsub('t.jpg', '.jpg')

      image_url
    end

    def self.parse_id_from_url(entity, url)

      id_match = url.match("/#{entity}/(\\d+)/.*")

      id_match[1]
    end

  end

end