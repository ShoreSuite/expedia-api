# frozen_string_literal: true

require 'expedia/api/client'

RSpec.describe Expedia::API::Client do
  it 'should have the expected attributes' do
    client = Expedia::API::Client.new 'SampleUserName', 'SamplePassword'
    expect(client.eqc_username).to eq('SampleUserName')
    expect(client.eqc_password).to eq('SamplePassword')
  end

  it 'should use environment variable by default' do
    ENV['EQC_USERNAME'] = 'SampleUserName'
    ENV['EQC_PASSWORD'] = 'SamplePassword'
    client = Expedia::API::Client.new
    expect(client.eqc_username).to eq('SampleUserName')
    expect(client.eqc_password).to eq('SamplePassword')
  end
end
