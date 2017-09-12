# frozen_string_literal: true

require 'representable'

# The Expedia 'namespace'
module Expedia
  # A RatePlan
  class RatePlan < Resource
    attributes %i[resource_id name rate_acquisition_type]

    collection :distribution_rules do
      properties %i[expedia_id partner_code distribution_model manageable]
      property :compensation do
        properties %i[percent min_amount]
      end
    end

    #     "resourceId": 209102875,
    #     "name": "RoomOnly",
    #     "rateAcquisitionType": "SellLAR",
    #     "distributionRules": [
    #         {
    #             "expediaId": "209102875",
    #             "partnerCode": "RoomOnly",
    #             "distributionModel": "ExpediaCollect",
    #             "manageable": false,
    #             "compensation": {
    #                 "percent": 0.2,
    #                 "minAmount": 0
    #             }
    #         },
    #         {
    #             "expediaId": "209102875A",
    #             "partnerCode": "RoomOnly",
    #             "distributionModel": "HotelCollect",
    #             "manageable": true,
    #             "compensation": {
    #                 "percent": 0.2
    #             }
    #         }
    #     ],
    #     "status": "Active",
    #     "type": "Standalone",
    #     "pricingModel": "PerDayPricing",
    #     "occupantsForBaseRate": 2,
    #     "taxInclusive": false,
    #     "depositRequired": false,
    #     "creationDateTime": "2016-11-24T21:28:13Z",
    #     "lastUpdateDateTime": "2016-11-24T21:28:13Z",
    #     "cancelPolicy": {
    #         "defaultPenalties": [
    #             {
    #                 "deadline": 0,
    #                 "perStayFee": "None",
    #                 "amount": 0
    #             }
    #         ]
    #     },
    #     "additionalGuestAmounts": [
    #         {
    #             "dateStart": "2016-11-24",
    #             "dateEnd": "2079-06-06",
    #             "ageCategory": "Adult",
    #             "amount": 0
    #         }
    #     ],
    #     "minLOSDefault": 1,
    #     "maxLOSDefault": 28,
    #     "minAdvBookDays": 0,
    #     "maxAdvBookDays": 500,
    #     "bookDateStart": "1900-01-01",
    #     "bookDateEnd": "2079-06-06",
    #     "travelDateStart": "1901-01-01",
    #     "travelDateEnd": "2079-06-06",
    #     "mobileOnly": false,
    #     "_links": {
    #         "self": {
    #             "href": "https://services.expediapartnercentral.com/
    #                      properties/16636843/roomTypes/201788359/ratePlans/209102875"
    #         }
    #     }
  end
end
