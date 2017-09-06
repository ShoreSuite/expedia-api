# frozen_string_literal: true

require 'dotenv/load'

require 'simplecov'

module SimpleCov
  # SimpleCov::Configuration
  module Configuration
    def clean_filters
      @filters = []
    end
  end
end

SimpleCov.configure do
  clean_filters
  load_adapter 'test_frameworks'
end

ENV['COVERAGE'] && SimpleCov.start do
  add_filter '/.rvm/'
end
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'expedia'

require 'rspec/expectations'
