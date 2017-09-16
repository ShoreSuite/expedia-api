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
      attr_reader :eqc_username, :eqc_password

      # Creates a new `CLIENT`
      def initialize(*args)
        if args.count == 2
          @eqc_username = args[0]
          @eqc_password = args[1]
        else
          @eqc_username = ENV['EQC_USERNAME']
          @eqc_password = ENV['EQC_PASSWORD']
        end
      end

      private

      def make_conn
        Faraday.new url: 'https://services.expediapartnercentral.com' do |faraday|
          faraday.request :url_encoded # form-encode POST params
          if ENV['EQC_DEBUG_LOG']
            faraday.response :logger # log requests to STDOUT
          end
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
          faraday.basic_auth(@eqc_username, @eqc_password)
        end
      end
    end
  end
end
