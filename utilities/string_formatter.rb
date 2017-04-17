module Railgun

  class StringFormatter

    def self.encodedHTML(string)
      require 'nokogiri/html'
      Nokogiri::HTML.parse(string).text
    end

  end

end
