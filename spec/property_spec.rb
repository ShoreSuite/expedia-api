# frozen_string_literal: true

require 'expedia/property'

RSpec.describe Expedia::Property do
  it 'should have attributes' do
    expect(Expedia::Property.attributes).to_not be_empty
  end
end
