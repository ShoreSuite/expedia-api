# frozen_string_literal: true

require 'expedia/api/client'

RSpec.describe Expedia::API::Client do
  it 'accepts a username and password as a hash initializer parameter' do
    client = Expedia::API::Client.new username: 'test', password: 'secret'
    expect(client.username).to eq('test')
    expect(client.password).to eq('secret')
  end

  it 'defaults to the EQC_USERNAME and EQC_PASSWORD in the environment' do
    ENV['EQC_USERNAME'] = 'env_username'
    ENV['EQC_PASSWORD'] = 'env_password'
    client = Expedia::API::Client.new
    expect(client.username).to eq('env_username')
    expect(client.password).to eq('env_password')
  end
end
