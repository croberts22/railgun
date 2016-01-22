require 'rake/testtask'

Rake::TestTask.new do |t|
  ENV['COVERAGE'] = 'true'
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

task :default => :test