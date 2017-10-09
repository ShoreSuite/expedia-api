# frozen_string_literal: true

require 'expedia/api/client'
require 'expedia/api/ar'
RSpec.describe Expedia::API::Client, :vcr do
  describe 'post_ar' do
    it 'should update availability' do
      client = Expedia::API::Client.new username: 'EQC16636797hotel', password: 'Te$ting123'
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
  end
end
