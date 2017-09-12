# frozen_string_literal: true

require 'expedia/room_type'

RSpec.describe Expedia::RoomType do
  it 'should have the expected attributes' do
    expected_attributes = %w[resourceId partnerCode name status ageCategories maxOccupancy
                             standardBedding smokingPreferences].map(&:underscore).map(&:to_sym)
    expect(Expedia::RoomType.attributes).to eq(expected_attributes)
  end
end
