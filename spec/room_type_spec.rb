# frozen_string_literal: true

require 'expedia/room_type'

RSpec.describe Expedia::RoomType do
  it 'should have the expected attributes' do
    expected_attributes = %w[resourceId partnerCode name status ageCategories maxOccupancy
                             standardBedding smokingPreferences].map(&:underscore).map(&:to_sym)
    expect(Expedia::RoomType.attributes).to eq(expected_attributes)
  end

  # rubocop:disable Metrics/BlockLength
  it 'should have a to_json method' do
    # rubocop:enable Metrics/BlockLength
    # rubocop:disable Style/NumericLiterals
    room_type = Expedia::RoomType.new resource_id: 201788359,
                                      partner_code: 'RoomCode',
                                      name: OpenStruct.new(value: 'Standard Room'),
                                      status: 'Active',
                                      age_categories: [
                                        OpenStruct.new(category: 'Adult', min_age: 18),
                                        OpenStruct.new(category: 'Infant', min_age: 0)
                                      ]
    expected = {
      'resourceId': 201788359,
      'partnerCode': 'RoomCode',
      'name': {
        'value': 'Standard Room'
      },
      'status': 'Active',
      'ageCategories': [
        {
          'category': 'Adult',
          'minAge': 18
        },
        {
          'category': 'Infant',
          'minAge': 0
        }
      ]
    }.to_json
    # rubocop:enable Style/NumericLiterals
    expect(room_type.to_json).to eq(expected)
  end
end
