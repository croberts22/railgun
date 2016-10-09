require 'chronic'

module Railgun

  class DateFormatter

    def date_from_string(date_string)
      return nil if !date_string
      Chronic.parse(date_string, guess: :begin)
    end

  end

end