# frozen_string_literal: true

require 'expedia/api/client'
require 'expedia/api/ar'
RSpec.describe Expedia::API::Client, :vcr do
  describe 'post_ar' do
    it 'should update availability' do
      client = Expedia::API::Client.new
      property_id = client.list_properties.first.resource_id
      room_types = client.list_room_types(property_id).map do |room_type|
        {
          id: room_type.resource_id,
          closed: false,
          inventory: 10
        }
      end
      options = {
        start_date: '2017-11-01',
        end_date: '2017-11-15',
        room_types: room_types
      }
      response_status = client.post_ar(property_id, options)
      expect(response_status).to eq(200)
    end

    it 'should update the rate' do
      client = Expedia::API::Client.new
      property_id = client.list_properties.first.resource_id
      room_types = client.list_room_types(property_id).map do |room_type|
        rate_plans = [{
          id: '209998400A',
          closed: false,
          currency: 'USD',
          rate: 5000
        }]
        {
          id: room_type.resource_id,
          closed: false,
          rate_plans: rate_plans
        }
      end
      options = {
        start_date: '2017-11-01',
        end_date: '2017-11-15',
        room_types: room_types
      }
      response_status = client.post_ar(property_id, options)
      expect(response_status).to eq(200)
    end

    # rubocop:disable Metrics/BlockLength
    it 'should update the rate restrictions' do
      # rubocop:enable Metrics/BlockLength
      client = Expedia::API::Client.new
      property_id = client.list_properties.first.resource_id
      room_types = client.list_room_types(property_id).map do |room_type|
        restrictions = {
          minLOS: 1,
          maxLOS: 2,
          closedToArrival: false,
          closedToDeparture: false
        }
        rate_plans = [{
          id: '209998400A',
          closed: false,
          restrictions: restrictions
        }]
        {
          id: room_type.resource_id,
          closed: false,
          rate_plans: rate_plans
        }
      end
      options = {
        start_date: '2017-11-01',
        end_date: '2017-11-15',
        room_types: room_types
      }
      response_status = client.post_ar(property_id, options)
      expect(response_status).to eq(200)
    end

    it 'should update the rate restrictions with only MinLOS' do
      # rubocop:enable Metrics/BlockLength
      client = Expedia::API::Client.new
      property_id = client.list_properties.first.resource_id
      room_types = client.list_room_types(property_id).map do |room_type|
        restrictions = {
          minLOS: 5
        }
        rate_plans = [{
          id: '209998400A',
          closed: false,
          restrictions: restrictions
        }]
        {
          id: room_type.resource_id,
          closed: false,
          rate_plans: rate_plans
        }
      end
      options = {
        start_date: '2017-11-01',
        end_date: '2017-11-15',
        room_types: room_types
      }
      response_status = client.post_ar(property_id, options)
      expect(response_status).to eq(200)
    end

    it 'should update the rate restrictions with only MaxLOS' do
      # rubocop:enable Metrics/BlockLength
      client = Expedia::API::Client.new
      property_id = client.list_properties.first.resource_id
      room_types = client.list_room_types(property_id).map do |room_type|
        restrictions = {
          maxLOS: 2
        }
        rate_plans = [{
          id: '209998400A',
          closed: false,
          restrictions: restrictions
        }]
        {
          id: room_type.resource_id,
          closed: false,
          rate_plans: rate_plans
        }
      end
      options = {
        start_date: '2017-11-01',
        end_date: '2017-11-15',
        room_types: room_types
      }
      response_status = client.post_ar(property_id, options)
      expect(response_status).to eq(200)
    end
  end
end
