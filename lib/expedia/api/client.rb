# frozen_string_literal: true

require 'active_support/core_ext/hash'
require 'faraday'
require 'json'

require 'expedia/property'
require 'expedia/room_type'
require 'expedia/rate_threshold'
require 'expedia/rate_plan'
require 'expedia/api/product'
require 'expedia/api/parr'
require 'expedia/api/ar'

# The Expedia 'namespace'
module Expedia
  ENV_VARS = %w[EQC_PROPERTY_ID EQC_USERNAME EQC_PASSWORD EQC_DEBUG_LOG].freeze

  # Expedia::API
  module API
    # The main Expedia API client
    class Client
      include Expedia::API::Product
      include Expedia::API::Parr
      include Expedia::API::AR

      attr_reader :username, :password

      # Initialize an Expedia::API::Client by passing in a hash:
      #
      # ```
      #   client = Expedia::API::Client.new username: 'expedia', password: 'secret'
      # ```
      #
      # Otherwise, the client will attempt to default to any credentials found in
      # the environment variables `EQC_USERNAME` and `EQC_PASSWORD`
      def initialize(options = {})
        @username = options[:username] || ENV['EQC_USERNAME']
        @password = options[:password] || ENV['EQC_PASSWORD']
      end

      private

      def make_conn
        Faraday.new url: 'https://services.expediapartnercentral.com' do |faraday|
          faraday.request :url_encoded # form-encode POST params
          if ENV['EQC_DEBUG_LOG']
            faraday.response :logger # log requests to STDOUT
          end
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
          faraday.basic_auth(username, password)
        end
      end
    end
  end
end
