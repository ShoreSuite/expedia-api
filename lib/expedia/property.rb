# frozen_string_literal: true

require 'representable'

# The Expedia 'namespace'
module Expedia
  # Base class for all mappable resources
  class Resource
    class << self
      def attributes(*args)
        @attributes ||= []
        unless args.empty?
          f = args.first
          if f.is_a?(Array) && f.all? { |a| a.is_a?(Symbol) }
            @attributes += f
            f.each do |attr|
              attr_accessor attr
            end
          end
        end
        @attributes
      end

      def attribute_names
        attributes.map(&:to_s)
      end
    end

    def to_s
      data = self.class.attributes.map do |attr|
        v = send(attr)
        "#{attr}: #{v}"
      end.join(' ')
      "<#{self.class}@0x#{format('%014x', object_id << 1)} #{data}>"
    end
  end

  # A Product
  class Property < Resource
    attributes %i[resourceId name partnerCode status currency address distributionModels
                  rateAcquisitionType taxInclusive pricingModel baseAllocationEnabled
                  minLOSThreshold cancellationTime timezone reservationCutOff]

    # An Address
    class Address < Resource
      attributes %i[line1 line2 city state postalCode countryCode]
    end

    # For JSON & XML representation
    class PropertyRepresenter < Representable::Decorator
      include Representable::JSON
      include Representable::Hash
      include Representable::Hash::AllowSymbols

      Property.attribute_names.each do |attr|
        property attr
      end
    end
  end
end

require 'expedia/api'
