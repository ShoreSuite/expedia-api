# frozen_string_literal: true

require 'representable'

# The Expedia 'namespace'
module Expedia
  # A Product
  class RateThreshold < Resource
    attributes %i[type minAmount maxAmount source]
  end
end
