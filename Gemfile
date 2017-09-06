# frozen_string_literal: true

source 'https://rubygems.org'

# Add dependencies required to use your gem here.
# Example:

# Foundational
gem 'activesupport', '~> 5.0'
gem 'faraday', '~> 0.9.2'
gem 'json', '~> 2.1.0'
gem 'money', '~> 6.9.0'
gem 'representable', '~> 3.0.4'

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.

group :development do
  gem 'dotenv', '~> 2.2.1'
  gem 'juwelier', '~> 2.1.0'
  gem 'rainbow', '~> 2.2.2', require: false
  gem 'rubocop', '~> 0.48.1', require: false
  gem 'yard', '~> 0.9.9', require: false

  # Code coverage
  gem 'simplecov', '~> 0.14.1', require: false

  # Use cucumber & rspec for tests
  gem 'capybara', '~> 2.14.0', require: false
  gem 'cucumber', '~> 2.4.0', require: false
  gem 'rspec', '~> 3.6.0', require: false

  # JSON path to help specify JSON tests
  gem 'jsonpath', '~> 0.5.8', require: false

  # WebMock and VCR to record HTTP interactions with other services
  gem 'vcr', '~> 3.0.3', require: false
  gem 'webmock', '~> 3.0.1', require: false
end
