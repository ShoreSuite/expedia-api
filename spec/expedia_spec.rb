# frozen_string_literal: true
require 'rspec'

RSpec.describe 'My behaviour' do
  it 'should do something' do
    expect(ENV['EQC_USERNAME']).to_not be_nil, "ENV['EQC_USERNAME'] not set! export EQC_USERNAME or use a .env file"
  end
end
