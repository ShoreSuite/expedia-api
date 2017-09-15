# frozen_string_literal: true

require 'expedia/api/client'
require 'expedia/api/parr'

RSpec.describe Expedia::API::Client, :vcr do
  describe 'fetch_parr' do
    # rubocop:disable Metrics/BlockLength
    it 'should retrieve the product availability and rates' do
      # rubocop:enable Metrics/BlockLength
      client = Expedia::API::Client.new
      product_list = client.fetch_parr
      expect(product_list).to be_a(Expedia::API::Parr::ProductList)
      expect(product_list.hotel).to be_a(OpenStruct)
      expect(product_list.hotel.id).to eq('16636843')
      expect(product_list.hotel.name).to eq('EQC Hotel 321')
      expect(product_list.hotel.city).to eq('Région Test')
      expect(product_list.room_type).to be_a(Expedia::API::Parr::RoomType)
      expect(product_list.room_type.rate_plans).to be_a(Array)
      expect(product_list.room_type.rate_plans.count).to eq(4)
      expect(product_list.room_type.rate_plans[0].id).to eq('209102875A')
      expect(product_list.room_type.rate_plans[0].code).to eq('RoomOnly')
      expect(product_list.room_type.rate_plans[0].name).to eq('RoomOnly')
      expect(product_list.room_type.rate_plans[0].distribution_model).to eq('HotelCollect')
      expect(product_list.room_type.rate_plans[1].id).to eq('209102875')
      expect(product_list.room_type.rate_plans[1].code).to eq('RoomOnly')
      expect(product_list.room_type.rate_plans[1].name).to eq('RoomOnly')
      expect(product_list.room_type.rate_plans[1].distribution_model).to eq('ExpediaCollect')
      expect(product_list.room_type.rate_plans[2].id).to eq('209102974A')
      expect(product_list.room_type.rate_plans[2].code).to eq('RoomOnly2')
      expect(product_list.room_type.rate_plans[2].name).to eq('RoomOnly2')
      expect(product_list.room_type.rate_plans[2].distribution_model).to eq('HotelCollect')
      expect(product_list.room_type.rate_plans[3].id).to eq('209102974')
      expect(product_list.room_type.rate_plans[3].code).to eq('RoomOnly2')
      expect(product_list.room_type.rate_plans[3].name).to eq('RoomOnly2')
      expect(product_list.room_type.rate_plans[3].distribution_model).to eq('ExpediaCollect')
      expect(product_list.room_type.rate_plans.all? { |rp| rp.status == 'Active' }).to be true
      expect(product_list.room_type.rate_plans.all? { |rp| rp.type == 'Standalone' }).to be true
    end
  end
end
