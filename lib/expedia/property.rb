# frozen_string_literal: true

require 'expedia/resource'

# The Expedia 'namespace'
module Expedia
  # A Product
  class Property < Resource
    attributes %i[resourceId name partnerCode status currency distributionModels
                  rateAcquisitionType taxInclusive pricingModel baseAllocationEnabled
                  minLOSThreshold cancellationTime timezone reservationCutOff]

    # An Address
    class Address < Resource
      attributes %i[line1 line2 city state postalCode countryCode]
    end

    property :address, class: Address

    # For JSON & XML representation
    class Representer < Representable::Decorator
      include Representable::JSON
      include Representable::Hash
      include Representable::Hash::AllowSymbols

      Property.raw_attribute_names.each do |attr|
        next if %w[address reservationCutOff].include?(attr)
        property attr.underscore, as: attr
      end

      property :address, class: Address do
        Address.raw_attribute_names.each do |attr|
          property attr.underscore, as: attr
        end
      end

      property :reservation_cut_off, as: 'reservationCutOff', class: OpenStruct do
        property :time
        property :day
      end
    end
  end
end
