# frozen_string_literal: true

require 'active_support/core_ext/hash'
require 'faraday'
require 'json'

require 'expedia/property'
require 'expedia/room_type'
require 'expedia/rate_threshold'
require 'expedia/api/product'
require 'expedia/api/parr'

ENV_VARS = %w[EQC_PROPERTY_ID EQC_USERNAME EQC_PASSWORD].freeze

# The Expedia 'namespace'
module Expedia
  ENV_VARS.each do |key|
    const_set key, ENV[key]
  end
  # Expedia::API
  module API
    # The main Expedia API client
    class Client
      include Expedia::API::Product
      include Expedia::API::Parr

      private

      def make_conn
        Faraday.new url: 'https://services.expediapartnercentral.com' do |faraday|
          faraday.request :url_encoded # form-encode POST params
          if ENV['EQC_DEBUG_LOG']
            faraday.response :logger # log requests to STDOUT
          end
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
          faraday.basic_auth(EQC_USERNAME, EQC_PASSWORD)
        end
      end
    end
  end
end
