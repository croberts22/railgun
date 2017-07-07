module Railgun

  class Review < Resource

    attr_accessor :username, :user_id, :user_url, :user_image_url
    attr_accessor :id, :helpful_review_count, :date, :episodes_watched, :episodes_total, :review
    attr_accessor :rating

    def rating
      @rating ||= {}
    end

    def attributes
      {
          user: {
              name: username,
              id: user_id,
              url: user_url,
              image_url: user_image_url
          },

          review: {
              id: id,
              date: date,
              helpful_review_count: helpful_review_count,
              episodes_watched: episodes_watched,
              episodes_total: episodes_total,
              review: review,
              rating: rating
          }
      }
    end

  end

end