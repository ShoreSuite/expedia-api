# frozen_string_literal: true

require 'expedia/api/client'
require 'expedia/api/parr'

RSpec.describe Expedia::API::Client, :vcr do
  describe 'fetch_parr' do
    it 'should retrieve the product availability and rates' do
      client = Expedia::API::Client.new
      parr = client.fetch_parr
      expect(parr).to be_a(Expedia::API::Parr::Hotel)
    end
  end
end
