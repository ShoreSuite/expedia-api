# frozen_string_literal: true

require 'expedia/api/client'
require 'expedia/property'

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
end
