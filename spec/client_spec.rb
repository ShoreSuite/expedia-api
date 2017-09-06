# frozen_string_literal: true

require 'expedia/api/client'

RSpec.describe Expedia::API::Client, :vcr do
  it 'should do something' do
    client = Expedia::API::Client.new
    properties = client.properties
    expect(properties).to_not be_nil
    p properties
  end
end
