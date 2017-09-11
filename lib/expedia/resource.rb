# frozen_string_literal: true

require 'representable'

module Expedia
  # Base class for all mappable resources
  class Resource
    class << self
      def attributes(*args)
        @raw_attribute_names ||= []
        @attributes ||= []
        unless args.empty?
          f = args.first
          if f.is_a?(Array) && f.all? { |a| a.is_a?(Symbol) }
            @raw_attribute_names += f
            # Use Ruby underscore variable name convention
            f.map! { |attr| attr.to_s.underscore }
            @attributes += f
            f.each do |attr|
              attr_accessor attr
            end
          end
        end
        @attributes
      end

      def raw_attribute_names
        @raw_attribute_names.map(&:to_s)
      end

      def attribute_names
        @attributes.map(&:to_s)
      end
    end

    def to_s
      data = self.class.attributes.map do |attr|
        v = send(attr)
        next unless v
        vv = v.is_a?(String) ? v.inspect : v.to_s
        "#{attr}: #{vv}"
      end.compact.join(' ')
      "<#{self.class}:0x#{format('%014x', object_id << 1)} #{data}>"
    end
  end
end
