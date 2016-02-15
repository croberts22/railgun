module Railgun

  class Keys

    def self.myanimelist_api_key
      ENV['USER_AGENT']
    end

    def self.rollbar_access_token
      ENV['ROLLBAR_ACCESS_TOKEN']
    end

  end

end
