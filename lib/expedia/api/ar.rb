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
      def post_ar(property_id, options = {})
        # rubocop:enable Metrics/AbcSize
        # rubocop:enable Metrics/MethodLength
        conn = make_conn
        resp = conn.post '/eqc/ar' do |req|
          req.headers['Content-Type'] = 'text/xml'
          builder = Nokogiri::XML::Builder.new do
            AvailRateUpdateRQ xmlns: 'http://www.expediaconnect.com/EQC/AR/2011/06' do
              Authentication username: username, password: password
              Hotel id: property_id
              AvailRateUpdate do
                DateRange from: options[:start_date], to: options[:end_date]
                options[:room_types].each do |room_type|
                  RoomType id: room_type[:id], closed: room_type[:closed] do
                    Inventory totalInventoryAvailable: room_type[:inventory] unless room_type[:inventory]
                  end
                end
              end
            end
          end
          puts builder.to_xml if ENV.key?('EQC_DEBUG_LOG') && ENV['EQC_DEBUG_LOG']
          req.body = builder.to_xml
        end
        doc = Nokogiri::XML(resp.body)
        if doc.at('Success')
          200
        else
          400
        end
      end
    end
  end
end
