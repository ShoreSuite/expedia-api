# frozen_string_literal: true

require 'expedia/api/client'
require 'expedia/property'
require 'expedia/rate_threshold'
require 'expedia/rate_plan'
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
      expect(property.resource_id).to eq(16636797)
      # rubocop:enable Style/NumericLiterals
      expect(property.name).to eq('EQC Hotel 304')
      expect(property.partner_code).to eq('16636797')
      expect(property.address.line1).to eq('1234 Test Street')
      expect(property.address.city).to eq('Région Test')
      expect(property.address.country_code).to eq('USA')
      expect(property.distribution_models).to eq(%w[ExpediaCollect HotelCollect])
      expect(property.rate_acquisition_type).to eq('SellLAR')
      expect(property.pricing_model).to eq('OccupancyBasedPricing')
      expect(property.base_allocation_enabled).to be false
      expect(property.cancellation_time).to eq('18:00')
      expect(property.timezone).to eq('(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London')
      expect(property.reservation_cut_off.time).to eq('23:59')
      expect(property.reservation_cut_off.day).to eq('sameDay')
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
      expect(property.distribution_models).to eq(%w[ExpediaCollect HotelCollect])
      expect(property.rate_acquisition_type).to eq('SellLAR')
      expect(property.pricing_model).to eq('PerDayPricing')
      expect(property.base_allocation_enabled).to be false
      expect(property.min_lost_threshold).to eq(1)
      expect(property.cancellation_time).to eq('18:00')
      expect(property.timezone).to eq('(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London')
      expect(property.reservation_cut_off.time).to eq('23:59')
      expect(property.reservation_cut_off.day).to eq('sameDay')
    end
  end

  describe 'list_room_types' do
    it 'should retrieve the room types for the given property_id' do
      client = Expedia::API::Client.new
      # rubocop:disable Style/NumericLiterals
      room_types = client.list_room_types(16636843)
      expect(room_types).to be_a Array
      expect(room_types.count).to eq(1)
      room_type = room_types.first
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
      expect(room_type.smoking_preferences).to eq(%w[Smoking Non-Smoking])
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
      expect(room_type.smoking_preferences).to eq(%w[Smoking Non-Smoking])
    end
  end

  describe 'fetch_rate_threshold' do
    it 'should fetch the room rate threshold' do
      expected_attributes = %w[type minAmount maxAmount source].map(&:underscore).map(&:to_sym)
      expect(Expedia::RateThreshold.attributes).to eq(expected_attributes)
      client = Expedia::API::Client.new
      # rubocop:disable Style/NumericLiterals
      rate_threshold = client.fetch_rate_threshold(16636843, 201788359)
      # rubocop:enable Style/NumericLiterals
      expect(rate_threshold).to be_a Expedia::RateThreshold
      expect(rate_threshold.type).to eq('SellLAR')
      expect(rate_threshold.min_amount).to eq(10.8184)
      expect(rate_threshold.max_amount).to eq(540.9212)
      expect(rate_threshold.source).to eq('RecentBookings')
    end
  end

  describe 'list_rate_plans' do
    # rubocop:disable Metrics/BlockLength
    it 'should retrieve all the rate plans for a specific room' do
      # rubocop:enable Metrics/BlockLength
      client = Expedia::API::Client.new
      # rubocop:disable Style/NumericLiterals
      rate_plan = client.list_rate_plans(16636797, 201788559)
      expect(rate_plan).to be_a Array
    end
  end

  describe 'fetch_rate_plan' do
    # rubocop:disable Metrics/BlockLength
    it 'should retrieve the rate plan with the given id' do
      # rubocop:enable Metrics/BlockLength
      client = Expedia::API::Client.new
      # rubocop:disable Style/NumericLiterals
      rate_plan = client.fetch_rate_plan(16636843, 201788359, 209102875)
      expect(rate_plan).to be_a Expedia::RatePlan
      expect(rate_plan.resource_id).to eq(209102875)
      # rubocop:enable Style/NumericLiterals
      expect(rate_plan.distribution_rules).to be_a Array
      expect(rate_plan.distribution_rules.count).to eq(2)
      first_distribution_rule = rate_plan.distribution_rules.first
      expect(first_distribution_rule.expedia_id).to eq('209102875')
      expect(first_distribution_rule.partner_code).to eq('RoomOnly')
      expect(first_distribution_rule.distribution_model).to eq('ExpediaCollect')
      expect(first_distribution_rule.manageable).to be false
      expect(first_distribution_rule.compensation.percent).to eq(0.2)
      expect(first_distribution_rule.compensation.min_amount).to eq(0)
      expect(rate_plan.status).to eq('Active')
      expect(rate_plan.type).to eq('Standalone')
      expect(rate_plan.pricing_model).to eq('PerDayPricing')
      expect(rate_plan.occupants_for_base_rate).to eq(2)
      expect(rate_plan.tax_inclusive).to be false
      expect(rate_plan.deposit_required).to be false
      expect(rate_plan.creation_date_time).to be_a DateTime
      expect(rate_plan.creation_date_time).to eq(DateTime.parse('2016-11-24T21:28:13Z'))
      expect(rate_plan.last_update_date_time).to be_a DateTime
      expect(rate_plan.last_update_date_time).to eq(DateTime.parse('2016-11-24T21:28:13Z'))
      expect(rate_plan.cancel_policy.default_penalties).to be_a Array
      expect(rate_plan.cancel_policy.default_penalties.count).to eq(1)
      expect(rate_plan.cancel_policy.default_penalties.first.deadline).to eq(0)
      expect(rate_plan.cancel_policy.default_penalties.first.per_stay_fee).to eq('None')
      expect(rate_plan.cancel_policy.default_penalties.first.amount).to eq(0)
      expect(rate_plan.additional_guest_amounts).to be_a Array
      expect(rate_plan.additional_guest_amounts.count).to eq(1)
      expect(rate_plan.additional_guest_amounts.first.date_start).to be_a Date
      expect(rate_plan.additional_guest_amounts.first.date_start).to eq(Date.new(2016, 11, 24))
      expect(rate_plan.additional_guest_amounts.first.date_end).to be_a Date
      expect(rate_plan.additional_guest_amounts.first.date_end).to eq(Date.new(2079, 6, 6))
      expect(rate_plan.additional_guest_amounts.first.age_category).to eq('Adult')
      expect(rate_plan.additional_guest_amounts.first.amount).to eq(0)
      expect(rate_plan.min_los_default).to eq(1)
      expect(rate_plan.max_los_default).to eq(28)
      expect(rate_plan.min_adv_book_days).to eq(0)
      expect(rate_plan.max_adv_book_days).to eq(500)
      expect(rate_plan.book_date_start).to eq(Date.new(1900, 1, 1))
      expect(rate_plan.book_date_end).to eq(Date.new(2079, 6, 6))
      expect(rate_plan.travel_date_start).to eq(Date.new(1901, 1, 1))
      expect(rate_plan.travel_date_end).to eq(Date.new(2079, 6, 6))
      expect(rate_plan.mobile_only).to be false
    end
  end
end
