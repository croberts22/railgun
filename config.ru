require 'rubygems'
require 'bundler'
require 'yaml'

Bundler.require

dalli_config = YAML.load(IO.read(File.join('config', 'dalli.yml')))[ENV['RACK_ENV']]

use Rack::Cache,
    :metastore => "memcached://#{dalli_config[:server]}/meta",
    :entitystore => "memcached://#{dalli_config[:server]}/body",
    :default_ttl => dalli_config[:expires_in],
    :allow_reload => true,
    :cache_key => Proc.new { |request|
      if request.env['HTTP_ORIGIN']
        [Rack::Cache::Key.new(request).generate, request.env['HTTP_ORIGIN']].join
      else
        Rack::Cache::Key.new(request).generate
      end
    }

# Used to whitelist web requests.
ENV['USER_AGENT'] = 'api-MyAniList-0529FA876D3D7805641D09E06AEE157D'

# Temporarily used to mess around with IP whitelisting
# ENV['INTERFACE']  = '192.185.52.170'

require './app'
run App