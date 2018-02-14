module Railgun

  require 'digest'
  require 'time'

  class RequestHelper

    def self.generate_etag(resource, id, date, offset = 3)
      Digest::MD5.hexdigest "#{resource}-#{id}-#{date.yday / offset}"
    end

  end

end