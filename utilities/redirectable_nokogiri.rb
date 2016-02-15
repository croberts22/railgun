require 'nokogiri'

module Railgun

  class RedirectableNokogiri
    attr_accessor :nokogiri, :redirected
  end

end