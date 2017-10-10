# frozen_string_literal: true

module Expedia
  module API
    # The Product API module, meant to be `included` into the Expedia::API::Client class
    module Product
      def list_properties
        conn = make_conn
        resp = conn.get '/products/properties'
        json = JSON.parse(resp.body).with_indifferent_access
        json[:entity].map do |entity|
          Property.from_hash(entity)
        end
      end

      def fetch_property(property_id)
        conn = make_conn
        resp = conn.get "/products/properties/#{property_id}"
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

      def list_rate_plans(property_id, room_type_id)
        conn = make_conn
        resp = conn.get "/products/properties/#{property_id}/roomTypes/#{room_type_id}/ratePlans"
        json = JSON.parse(resp.body).with_indifferent_access
        json[:entity].map do |rate_plan|
          RatePlan.from_hash(rate_plan)
        end
      end

      def fetch_rate_plan(property_id, room_type_id, rate_plan_id)
        conn = make_conn
        resp = conn.get "/products/properties/#{property_id}/roomTypes/#{room_type_id}/ratePlans/#{rate_plan_id}"
        json = JSON.parse(resp.body).with_indifferent_access
        RatePlan.from_hash(json[:entity])
      end
    end
  end
end
