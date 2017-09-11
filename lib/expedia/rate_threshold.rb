# frozen_string_literal: true

require 'representable'

# The Expedia 'namespace'
module Expedia
  # A Product
  class RateThreshold < Resource
    attributes %i[type minAmount maxAmount source]

    # For JSON & XML representation
    class Representer < Representable::Decorator
      include Representable::JSON
      include Representable::Hash
      include Representable::Hash::AllowSymbols

      RateThreshold.raw_attribute_names.each do |attr|
        property attr.underscore, as: attr
      end
    end
  end
end
