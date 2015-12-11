require "bundler/gem_tasks"
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/event_stream/**/*_test.rb'
  t.libs.push 'test'
end

task :default => :test
