# frozen_string_literal: true

require 'expedia/resource'

# The Expedia 'namespace'
module Expedia
  # A Product
  class Property < Resource
    attributes %w[resourceId name partnerCode status currency distributionModels
                  rateAcquisitionType taxInclusive pricingModel baseAllocationEnabled
                  cancellationTime timezone].map(&:underscore)

    property :min_lost_threshold, as: 'minLOSThreshold'

    # An Address
    class Address < Resource
      attributes %w[line1 line2 city state postalCode countryCode].map(&:underscore)
    end

    property :address, class: Address
    property :reservation_cut_off do
      property :time
      property :day
    end
  end
end
