# frozen_string_literal: true

require 'expedia/resource'

# The Expedia 'namespace'
module Expedia
  # A Product
  class RoomType < Resource
    attributes %w[resourceId partnerCode status].map(&:underscore)

    property :name do
      property :value
    end

    collection :age_categories do
      property :category
      property :min_age
    end

    property :max_occupancy do
      property :total
      property :adults
      property :children
    end

    collection :standard_bedding do
      collection :option do
        property :quantity
        property :type
        property :size
      end
    end

    collection :smoking_preferences
  end
end
