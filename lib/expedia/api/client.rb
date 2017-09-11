# frozen_string_literal: true

require 'active_support/core_ext/hash'
require 'faraday'
require 'json'

require 'expedia/property'
require 'expedia/room_type'
require 'expedia/rate_threshold'

ENV_VARS = %w[EQC_PROPERTY_ID EQC_USERNAME EQC_PASSWORD].freeze

# The Expedia 'namespace'
module Expedia
  ENV_VARS.each do |key|
    const_set key, ENV[key]
  end
  # Expedia::API
  module API
    # The main Expedia API client
    class Client
      def list_properties
        conn = make_conn
        resp = conn.get '/products/properties'
        json = JSON.parse(resp.body).with_indifferent_access
        json[:entity].map do |entity|
          Property.from_hash(entity)
        end
      end

      def fetch_property(resource_id)
        conn = make_conn
        resp = conn.get "/products/properties/#{resource_id}"
        json = JSON.parse(resp.body).with_indifferent_access
        Property.from_hash(json[:entity])
      end

      def list_room_types(property_id)
        conn = make_conn
        resp = conn.get "/products/properties/#{property_id}/roomTypes"
        json = JSON.parse(resp.body).with_indifferent_access
        json[:entity].map do |entity|
          RoomType.from_hash(entity)
        end
      end

      def fetch_room_type(property_id, room_type_id)
        conn = make_conn
        resp = conn.get "/products/properties/#{property_id}/roomTypes/#{room_type_id}"
        json = JSON.parse(resp.body).with_indifferent_access
        RoomType.from_hash(json[:entity])
      end

      def fetch_rate_threshold(property_id, room_type_id)
        conn = make_conn
        resp = conn.get "/products/properties/#{property_id}/roomTypes/#{room_type_id}/rateThresholds"
        json = JSON.parse(resp.body).with_indifferent_access
        RateThreshold.from_hash(json[:entity])
      end

      private

      def make_conn
        Faraday.new url: 'https://services.expediapartnercentral.com' do |faraday|
          faraday.request :url_encoded # form-encode POST params
          if ENV['EQC_DEBUG_LOG']
            faraday.response :logger # log requests to STDOUT
          end
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
          faraday.basic_auth(EQC_USERNAME, EQC_PASSWORD)
        end
      end
    end
  end
end
