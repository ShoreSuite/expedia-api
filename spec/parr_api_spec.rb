# frozen_string_literal: true

require 'expedia/api/client'
require 'expedia/api/parr'

RSpec.describe Expedia::API::Client, :vcr do
  describe 'fetch_parr' do
    it 'should retrieve the product availability and rates' do
      client = Expedia::API::Client.new
      product_list = client.fetch_parr
      p product_list
      expect(product_list).to be_a(Expedia::API::Parr::ProductList)
      expect(product_list.hotel).to be_a(OpenStruct)
      expect(product_list.hotel.id).to eq('16636843')
      expect(product_list.hotel.name).to eq('EQC Hotel 321')
      expect(product_list.hotel.city).to eq('Région Test')
    end
  end
end
