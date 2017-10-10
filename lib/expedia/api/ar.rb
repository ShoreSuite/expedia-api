# frozen_string_literal: true

require 'active_support/concern'
require 'xml_mapper'
require 'nokogiri'
require 'expedia/resource'

module Expedia
  module API
    # Expedia QuickConnect Avail & Rates API
    # https://expediaconnectivity.com/apis/availability-rates-restrictions-booking-notification-retrieval-and-confirmation/expedia-quickconnect-avail-rates-api/quick-start.html
    module AR
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def post_ar(property_id, options = {})
        # rubocop:enable Metrics/AbcSize
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/PerceivedComplexity
        conn = make_conn
        # rubocop:disable Metrics/BlockLength
        resp = conn.post '/eqc/ar' do |req|
          req.headers['Content-Type'] = 'text/xml'
          builder = Nokogiri::XML::Builder.new do
            # rubocop:enable Metrics/BlockLength
            AvailRateUpdateRQ xmlns: 'http://www.expediaconnect.com/EQC/AR/2011/06' do
              Authentication username: username, password: password
              Hotel id: property_id
              AvailRateUpdate do
                DateRange from: options[:start_date], to: options[:end_date]
                options[:room_types].each do |room_type|
                  RoomType id: room_type[:id], closed: room_type[:closed] do
                    Inventory totalInventoryAvailable: room_type[:inventory] if room_type[:inventory]
                    room_type[:rate_plans]&.each do |rate_plan|
                      RatePlan id: rate_plan[:id], closed: rate_plan[:closed] do
                        if rate_plan[:rate]
                          Rate currency: rate_plan[:currency] do
                            PerDay rate: rate_plan[:rate]
                          end
                        end
                        if rate_plan[:restrictions]
                          restrictions = rate_plan[:restrictions]
                          Restrictions minLOS: restrictions[:minLOS], closedToArrival: restrictions[:closedToArrival],
                                       closedToDeparture: restrictions[:closedToDeparture],
                                       maxLOS: restrictions[:maxLOS]
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          puts builder.to_xml if ENV.key?('EQC_DEBUG_LOG') && ENV['EQC_DEBUG_LOG']
          req.body = builder.to_xml
        end
        doc = Nokogiri::XML(resp.body)
        puts "DOC => #{doc.to_xml.inspect}"
        if doc.at('Success')
          200
        else
          400
        end
      end
    end
  end
end
