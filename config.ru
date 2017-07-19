require 'rubygems'
require 'bundler'
require 'yaml'
require 'rollbar'
require_relative 'services/keys'

Bundler.require

# For local testing, fire up memcached and uncomment this:
# ENV['MEMCACHIER_SERVERS'] = 'localhost'
#
# if memcache_servers = ENV['MEMCACHIER_SERVERS']
#   use Rack::Cache,
#       verbose: true,
#       metastore:   "memcached://#{memcache_servers}/meta",
#       entitystore: "memcached://#{memcache_servers}/body",
#       default_ttl: 86400,
#       allow_reload: true,
#       cache_key: Proc.new { |request|
#         if request.env['HTTP_ORIGIN']
#           [Rack::Cache::Key.new(request).generate, request.env['HTTP_ORIGIN']].join
#         else
#           Rack::Cache::Key.new(request).generate
#         end
#       }
# end

if access_token = Railgun::Keys.rollbar_access_token
  Rollbar.configure do |config|
    config.access_token = access_token
    config.environment = Sinatra::Base.environment
  end
end

# Sync log output to Heroku.
$stdout.sync = true

require './app'
run App