require 'coveralls'
Coveralls.wear!
SimpleCov.command_name 'Unit Tests'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/test*.rb']
  t.verbose = true
end

task :default => :test