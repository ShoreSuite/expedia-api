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
      p property
      expect(property).to be_a Expedia::Property
      # rubocop:disable Style/NumericLiterals
      expect(property.resourceId).to eq(16636843)
      # rubocop:enable Style/NumericLiterals
      expect(property.name).to eq('EQC Hotel 321')
      expect(property.partnerCode).to eq('16636843')
    end
  end
end
