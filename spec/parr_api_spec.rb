# frozen_string_literal: true

require 'expedia/api/client'
require 'expedia/api/parr'

# rubocop:disable Metrics/BlockLength
# rubocop:disable Style/NumericLiterals
RSpec.describe Expedia::API::Client, :vcr do
  describe 'fetch_parr' do
    it 'should retrieve the product availability and rates' do
      client = Expedia::API::Client.new
      product_list = client.fetch_parr(16636843)
      expect(product_list).to be_a(Expedia::API::Parr::ProductList)
      expect(product_list.hotel).to be_a(OpenStruct)
      expect(product_list.hotel.id).to eq(16636843)
      expect(product_list.hotel.name).to eq('EQC Hotel 321')
      expect(product_list.hotel.city).to eq('Région Test')

      room_type = product_list.room_type
      expect(room_type).to be_a(Expedia::API::Parr::RoomType)
      expect(product_list.room_type.id).to eq(201788359)
      expect(product_list.room_type.code).to eq('RoomCode')
      expect(product_list.room_type.name).to eq('Standard Room')
      expect(product_list.room_type.status).to eq('Active')

      expect(product_list.room_type.rate_plans).to be_an_array_of_size(4)
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

    it 'supports :return_room_attributes option' do
      client = Expedia::API::Client.new
      product_list = client.fetch_parr(16636843, return_room_attributes: true)
      expect(product_list).to be_a(Expedia::API::Parr::ProductList)
      expect(product_list.hotel).to be_a(OpenStruct)
      expect(product_list.hotel.id).to eq(16636843)
      expect(product_list.hotel.name).to eq('EQC Hotel 321')
      expect(product_list.hotel.city).to eq('Région Test')

      room_type = product_list.room_type
      expect(room_type).to be_a(Expedia::API::Parr::RoomType)
      expect(room_type.id).to eq(201788359)
      expect(room_type.code).to eq('RoomCode')
      expect(room_type.name).to eq('Standard Room')
      expect(room_type.status).to eq('Active')
      expect(room_type.smoking_pref).to eq('Either')
      expect(room_type.max_occupants).to eq(4)

      expect(room_type.bed_types).to be_an_array_of_size(1)
      expect(room_type.bed_types[0].id).to eq('1.18')
      expect(room_type.bed_types[0].name).to eq('1 twin bed')

      expect(room_type.occupancy_by_age).to be_an_array_of_size(2)
      expect(room_type.occupancy_by_age[0].age_category).to eq('Adult')
      expect(room_type.occupancy_by_age[0].min_age).to eq(18)
      expect(room_type.occupancy_by_age[0].max_occupants).to eq(4)
      expect(room_type.occupancy_by_age[1].age_category).to eq('Infant')
      expect(room_type.occupancy_by_age[1].min_age).to eq(0)
      expect(room_type.occupancy_by_age[1].max_occupants).to eq(1)

      expect(room_type.rate_thresholds).to be_an_array_of_size(2)
      expect(room_type.rate_thresholds[0].type).to eq('NetRate')
      expect(room_type.rate_thresholds[0].min_amount).to eq('96.00')
      expect(room_type.rate_thresholds[0].max_amount).to eq('4800.00')
      expect(room_type.rate_thresholds[0].source).to eq('RecentReservations')
      expect(room_type.rate_thresholds[1].type).to eq('SellRate')
      expect(room_type.rate_thresholds[1].min_amount).to eq('10.82')
      expect(room_type.rate_thresholds[1].max_amount).to eq('540.92')
      expect(room_type.rate_thresholds[1].source).to eq('RecentReservations')

      expect(room_type.rate_plans).to be_an_array_of_size(4)
      expect(room_type.rate_plans[0].id).to eq('209102875A')
      expect(room_type.rate_plans[0].code).to eq('RoomOnly')
      expect(room_type.rate_plans[0].name).to eq('RoomOnly')
      expect(room_type.rate_plans[0].distribution_model).to eq('HotelCollect')
      expect(room_type.rate_plans[1].id).to eq('209102875')
      expect(room_type.rate_plans[1].code).to eq('RoomOnly')
      expect(room_type.rate_plans[1].name).to eq('RoomOnly')
      expect(room_type.rate_plans[1].distribution_model).to eq('ExpediaCollect')
      expect(room_type.rate_plans[2].id).to eq('209102974A')
      expect(room_type.rate_plans[2].code).to eq('RoomOnly2')
      expect(room_type.rate_plans[2].name).to eq('RoomOnly2')
      expect(room_type.rate_plans[2].distribution_model).to eq('HotelCollect')
      expect(room_type.rate_plans[3].id).to eq('209102974')
      expect(room_type.rate_plans[3].code).to eq('RoomOnly2')
      expect(room_type.rate_plans[3].name).to eq('RoomOnly2')
      expect(room_type.rate_plans[3].distribution_model).to eq('ExpediaCollect')
      expect(room_type.rate_plans.all? { |rp| rp.status == 'Active' }).to be true
      expect(room_type.rate_plans.all? { |rp| rp.type == 'Standalone' }).to be true
    end
  end
end
