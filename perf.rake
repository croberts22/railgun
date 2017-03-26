namespace :perf do
  task :rack_load do
    require_relative "app"
    DERAILED_APP = App
  end
end
