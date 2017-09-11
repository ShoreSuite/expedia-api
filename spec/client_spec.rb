# frozen_string_literal: true

require 'expedia/api/client'
require 'expedia/property'
require 'expedia/room_type'

RSpec.describe Expedia::API::Client, :vcr do
  describe 'list_properties' do
    it 'should retrieve the properties' do
      client = Expedia::API::Client.new
      properties = client.list_properties
      expect(properties).to_not be_nil
      expect(properties).to be_a Array
      property = properties.first
      expect(property).to be_a Expedia::Property
      # rubocop:disable Style/NumericLiterals
      expect(property.resource_id).to eq(16636843)
      # rubocop:enable Style/NumericLiterals
      expect(property.name).to eq('EQC Hotel 321')
      expect(property.partner_code).to eq('16636843')
      expect(property.address.line1).to eq('1234 Test Street')
      expect(property.address.city).to eq('Région Test')
      expect(property.address.country_code).to eq('USA')
      expect(property.distribution_models).to be_a Array
      expect(property.distribution_models.count).to eq(2)
      expect(property.reservation_cut_off.time).to eq('23:59')
    end
  end

  describe 'fetch_property' do
    it 'should retrieve the property with the given id' do
      client = Expedia::API::Client.new
      # rubocop:disable Style/NumericLiterals
      property = client.fetch_property(16636843)
      expect(property).to be_a Expedia::Property
      expect(property.resource_id).to eq(16636843)
      # rubocop:enable Style/NumericLiterals
      expect(property.name).to eq('EQC Hotel 321')
      expect(property.partner_code).to eq('16636843')
      expect(property.address.line1).to eq('1234 Test Street')
      expect(property.address.city).to eq('Région Test')
      expect(property.address.country_code).to eq('USA')
      expect(property.distribution_models).to be_a Array
      expect(property.distribution_models.count).to eq(2)
      expect(property.reservation_cut_off.time).to eq('23:59')
    end
  end

  describe 'fetch_room_type' do
    it 'should retrieve the room type with the given id' do
      client = Expedia::API::Client.new
      # rubocop:disable Style/NumericLiterals
      room_type = client.fetch_room_type(16636843, 201788359)
      expect(room_type).to be_a Expedia::RoomType
      expect(room_type.resource_id).to eq(201788359)
      # rubocop:enable Style/NumericLiterals
      expect(room_type.partner_code).to eq('RoomCode')
      expect(room_type.name.value).to eq('Standard Room')
      expect(room_type.status).to eq('Active')
      expect(room_type.age_categories).to be_a(Array)
      expect(room_type.age_categories.count).to eq(2)
      expect(room_type.max_occupancy.total).to eq(4)
      expect(room_type.max_occupancy.adults).to eq(4)
      expect(room_type.max_occupancy.children).to eq(1)
      expect(room_type.standard_bedding).to be_a(Array)
      expect(room_type.standard_bedding.count).to eq(1)
      expect(room_type.standard_bedding.first.option).to be_a(Array)
      expect(room_type.standard_bedding.first.option.count).to eq(1)
      expect(room_type.standard_bedding.first.option.first.quantity).to eq(1)
      expect(room_type.standard_bedding.first.option.first.type).to eq('Twin Bed')
      expect(room_type.standard_bedding.first.option.first.size).to eq('Twin')
    end
  end
end
