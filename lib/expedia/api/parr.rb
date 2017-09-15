# frozen_string_literal: true

require 'active_support/concern'
require 'nokogiri'
require 'expedia/resource'

module Expedia
  module API
    # The Product, Availability and Rate Retrieval Request and Response API
    # https://expediaconnectivity.com/apis/product-management/expedia-quickconnect-products-availability-and-rates-retrieval-api/quick-start.html
    module Parr
      # An XmlResource mixin
      module XmlResource
        extend ActiveSupport::Concern
        class_methods do
          def attributes
            @attributes ||= []
          end

          def attribute(name, options = {})
            attributes << AttributeDefinition.new(name, options)
            attr_accessor name
          end

          def from_node(node)
            new.tap do |obj|
              attributes.each do |attr|
                obj.send("#{attr.name}=", node[attr.name])
              end
            end
          end
        end

        def initialize(*args)
          puts "#{self.class}.initialize(#{args.inspect})"
          self.class.attributes.zip(args).each do |attr, v|
            send("#{attr.name}=", v)
          end
        end

        AttributeDefinition = Struct.new(:name, :options) do
        end
      end

      # A ProductList
      ProductList = Struct.new :hotel, :room_type

      # A Hotel
      class Hotel
        include XmlResource

        attribute :id
        attribute :name
        attribute :city
      end

      def fetch_parr
        conn = make_conn
        resp = conn.post '/eqc/parr' do |req|
          req.body = <<~END
            <ProductAvailRateRetrievalRQ xmlns="http://www.expediaconnect.com/EQC/PAR/2013/07">
                <Authentication username="EQC16636843hotel" password="Btm6noE!&amp;ZC=TKaU"/>
                <Hotel id="16636843"/>
                <ParamSet>
                    <ProductRetrieval/>
                </ParamSet>
            </ProductAvailRateRetrievalRQ>
          END
        end
        doc = Nokogiri::XML(resp.body)
        product_list = doc.css('ProductAvailRateRetrievalRS ProductList')
        puts "product_list.count => #{product_list.count}"
        puts "product_list.children.count => #{product_list.children.count}"
        hotel_node = product_list.at('Hotel')
        Hotel.from_node(hotel_node)
      end
    end
  end
end
