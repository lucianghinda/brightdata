# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "yard"

Rake::TestTask.new(:test) do |t|
  t.libs << "test" << "lib"
  t.test_files = FileList["test/**/*_test.rb"].exclude("test/live/**/*")
end

Rake::TestTask.new("test:live") do |t|
  t.libs << "test" << "lib"
  t.test_files = FileList["test/live/**/*_test.rb"]
end

RuboCop::RakeTask.new

YARD::Rake::YardocTask.new

task default: %i[test rubocop]
