source 'https://rubygems.org'

ruby '2.4.0'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'nokogiri'
gem 'curb'
gem 'json'
gem 'builder'
gem 'rack'
gem 'rack-cache'
gem 'dalli'
gem 'rollbar'
gem 'chronic'
gem 'memcachier'
gem 'redis'

group :development do
  gem 'thin'
  gem 'rack-test'
  gem 'derailed_benchmarks'
  gem 'rack-mini-profiler'

  # For call-stack profiling flamegraphs (requires Ruby MRI 2.0.0+)
  gem 'flamegraph'
  gem 'stackprof'
end

group :test do
  gem 'rake'
  gem 'test-unit'
  gem 'coveralls', require: false
end
