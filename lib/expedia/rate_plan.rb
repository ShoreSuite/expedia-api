# frozen_string_literal: true

require 'representable'

# The Expedia 'namespace'
module Expedia
  # A RatePlan
  class RatePlan < Resource
    properties %i[resource_id name rate_acquisition_type]

    collection :distribution_rules do
      properties %i[expedia_id partner_code distribution_model manageable]
      property :compensation do
        properties %i[percent min_amount]
      end
    end

    properties %i[status type pricing_model occupants_for_base_rate tax_inclusive deposit_required]
    property :creation_date_time, type: DateTime
    property :last_update_date_time, type: DateTime

    property :cancel_policy do
      collection :default_penalties do
        properties %i[deadline per_stay_fee amount]
      end
    end

    collection :additional_guest_amounts do
      property :date_start, type: Date
      property :date_end, type: Date
      properties :age_category, :amount
    end

    raw_properties %w[minLOSDefault maxLOSDefault minAdvBookDays maxAdvBookDays]
    property :book_date_start, as: 'bookDateStart', type: Date
    property :book_date_end, as: 'bookDateEnd', type: Date
    property :travel_date_start, as: 'travelDateStart', type: Date
    property :travel_date_end, as: 'travelDateEnd', type: Date
    raw_property 'mobileOnly'
  end
end
