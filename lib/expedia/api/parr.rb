# frozen_string_literal: true

require 'active_support/concern'
require 'xml_mapper'
require 'nokogiri'
require 'expedia/resource'

module Expedia
  module API
    # The Product, Availability and Rate Retrieval Request and Response API
    # https://expediaconnectivity.com/apis/product-management/expedia-quickconnect-products-availability-and-rates-retrieval-api/quick-start.html
    module Parr
      # A RoomType
      class RoomType
        include XmlMapper::XmlResource

        attribute :id, type: Integer
        attributes :code, :name, :status, :smoking_pref
        attribute :max_occupants, type: Integer

        has_many :bed_type do
          attributes :id, :name
        end
        has_many :rate_plan do
          attributes :id, :code, :name, :status, :type
          attribute :distribution_model
        end
      end

      # A ProductList
      class ProductList
        include XmlMapper::XmlResource
        element :hotel do
          attribute :id, type: Integer
          attribute :name
          attribute :city
        end
        element :room_type, class: RoomType
      end

      FETCH_PARR_VALID_OPTIONS = %i[return_rate_link return_room_attributes return_rate_plan_attributes
                                    return_compensation return_cancel_policy].freeze

      # rubocop:disable Metrics/AbcSize
      def fetch_parr(property_id, options = {})
        # rubocop:enable Metrics/AbcSize
        conn = make_conn
        resp = conn.post '/eqc/parr' do |req|
          req.headers['Content-Type'] = 'text/xml'
          builder = Nokogiri::XML::Builder.new do
            ProductAvailRateRetrievalRQ xmlns: 'http://www.expediaconnect.com/EQC/PAR/2013/07' do
              Authentication username: username, password: password
              Hotel id: property_id
              ParamSet do
                opts = Hash[options.slice(*FETCH_PARR_VALID_OPTIONS).map { |k, v| [k.to_s.camelize(:lower), v] }]
                ProductRetrieval(opts)
              end
            end
          end
          puts builder.to_xml if ENV.key?('EQC_DEBUG_LOG') && ENV['EQC_DEBUG_LOG']
          req.body = builder.to_xml
        end
        doc = Nokogiri::XML(resp.body)
        ProductList.from_node(doc.at('ProductList'))
      end
    end
  end
end
