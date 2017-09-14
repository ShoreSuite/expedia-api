# encoding: utf-8
# frozen_string_literal: true

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'
require 'juwelier'
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = 'expedia'
  gem.homepage = 'http://github.com/aisrael/expedia'
  gem.license = 'MIT'
  gem.summary = 'Expedia API'
  gem.description = 'Expedia Quick Connect API gem'
  gem.email = 'aisrael@gmail.com'
  gem.authors = ['Alistair A. Israel']

  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task default: :spec

require 'yard'
YARD::Rake::YardocTask.new
