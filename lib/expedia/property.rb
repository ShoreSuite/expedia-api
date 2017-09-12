# frozen_string_literal: true

require 'expedia/resource'

# The Expedia 'namespace'
module Expedia
  # A Product
  class Property < Resource
    attributes %i[resourceId name partnerCode status currency distributionModels
                  rateAcquisitionType taxInclusive pricingModel baseAllocationEnabled
                  minLOSThreshold cancellationTime timezone]

    # An Address
    class Address < Resource
      attributes %i[line1 line2 city state postalCode countryCode]
    end

    property :address, class: Address
    property :reservationCutOff, class: OpenStruct do
      property :time
      property :day
    end
  end
end
