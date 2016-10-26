require 'chronic'

module Railgun

  class DateFormatter

    def date_from_string(date_string)
      return nil if !date_string
      date = Chronic.parse(date_string, guess: :begin)

      date.utc.iso8601 unless date == nil
    end

  end

end