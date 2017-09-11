# frozen_string_literal: true

require 'representable'

# The Expedia 'namespace'
module Expedia
  # A Product
  class RoomType < Resource
    attributes %i[resourceId partnerCode name status ageCategories maxOccupancy
                  standardBedding smokingPreferences]

    # For JSON & XML representation
    class Representer < Representable::Decorator
      include Representable::JSON
      include Representable::Hash
      include Representable::Hash::AllowSymbols

      RoomType.raw_attribute_names.each do |attr|
        next if %w[name ageCategories maxOccupancy standardBedding smokingPreferences].include?(attr)
        property attr.underscore, as: attr
      end

      property :name, class: OpenStruct do
        property :value
      end

      collection :age_categories, as: 'ageCategories', class: OpenStruct do
        property :category
        property :min_age, as: 'minAge'
      end

      property :max_occupancy, as: 'maxOccupancy', class: OpenStruct do
        property :total
        property :adults
        property :children
      end

      collection :standard_bedding, as: 'standardBedding', class: OpenStruct do
        collection :option, class: OpenStruct do
          property :quantity
          property :type
          property :size
        end
      end

      collection :smoking_preferences, as: 'smokingPreferences'
    end
  end
end
