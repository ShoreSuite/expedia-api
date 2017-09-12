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
      def property(raw_name, options = {}, &block)
        name = options.delete(:name) || raw_name.to_s.underscore
        properties[raw_name] = OpenStruct.new name: name,
                                              as: raw_name,
                                              options: options
        properties[raw_name][block] = block if block_given?
        attr_accessor name
      end

      # Define a collection using 'rawName', defaults to `OpenStruct`
      def collection(raw_name, options = {}, &block)
        name = options.delete(:name) || raw_name.to_s.underscore
        clazz = options.delete(:class) || OpenStruct
        collection[raw_name] = OpenStruct.new name: name,
                                              as: raw_name,
                                              options: options,
                                              class: clazz
        collections[raw_name][block] = block if block_given?
        attr_accessor name
      end

      def properties
        @properties ||= {}
      end

      def collections
        @collections ||= {}
      end

      def raw_attribute_names
        properties.keys.map(&:to_s)
      end

      def attribute_names
        properties.map(&:as)
      end

      protected

      def dynamically_create_representer
        this = self
        representer_class = Class.new(Representable::Decorator) do
          include Representable::JSON
          include Representable::Hash
          include Representable::Hash::AllowSymbols
          this.properties.each do |raw_name, prop|
            options = prop.options.merge as: raw_name
            property prop.name, options
          end
        end
        this.const_set(:Representer, representer_class)
      end
    end

    class << self
      def from_hash(hash)
        resource_class = self
        representer_class = if resource_class.constants.include?(:Representer)
                              resource_class.const_get(:Representer)
                            else
                              resource_class.dynamically_create_representer
                            end
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
