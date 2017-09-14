# frozen_string_literal: true

require 'representable'

# The Expedia 'namespace'
module Expedia
  # A Product
  class RateThreshold < Resource
    attributes %w[type minAmount maxAmount source].map(&:underscore)
  end
end
