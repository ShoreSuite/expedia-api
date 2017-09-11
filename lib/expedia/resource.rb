# frozen_string_literal: true

require 'representable'

module Expedia
  # Base class for all mappable resources
  class Resource
    class << self
      # Use
      #
      # ```
      #     attributes :foo, :bar
      # ```
      #
      # It will automatically create accessors using Ruby naming conventions, but
      # keep the original attribute names in `class.raw_attribute_names`
      def attributes(*args)
        unless args.empty?
          f = args.first
          if f.is_a?(Array) && f.all? { |a| a.is_a?(Symbol) }
            f.each { |attr| property attr }
          end
        end
        properties.keys
      end

      # Define a property using 'rawName'
      def property(raw_name, options = {})
        as = options.delete(:as) || raw_name.to_s.underscore
        properties[raw_name] = {
          name: raw_name,
          as: as,
          options: options
        }
        attr_accessor as
      end

      def properties
        @properties ||= {}
      end

      def raw_attribute_names
        properties.keys.map(&:to_s)
      end

      def attribute_names
        properties.map(&:as)
      end
    end

    class << self
      def from_hash(hash)
        resource_class = self
        representer_class = resource_class.const_get('Representer')
        representer_class.new(resource_class.new).from_hash(hash)
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
