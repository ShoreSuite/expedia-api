# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'representable'
require 'representable/coercion'

module Expedia
  # Base class for all mappable resources
  class Resource
    class << self
      # Declare properties in one go, e.g.
      #
      # ```
      #     attributes :name, :age
      # ```
      #
      # Is equivalent to
      #
      # ```
      #     property :name
      #     property :age
      # ```
      def attributes(*args)
        unless args.empty?
          props = args.first.is_a?(Array) ? args.first : args
          props.each { |attr| property attr.to_sym }
        end
        declarations.keys
      end

      alias properties attributes

      def raw_attributes(*args)
        return if args.empty?
        props = args.first.is_a?(Array) ? args.first : args
        props.each { |s| raw_property s }
      end
      alias raw_properties raw_attributes

      # Define a property using 'rawName', equivalent to
      #
      # ```
      #     property :raw_name, as: 'rawName'
      # ```
      def raw_property(raw_name, options = {}, &block)
        property raw_name.to_s.underscore, options.merge(as: raw_name), &block
      end

      # Define a property using 'attr_name', equivalent to
      #
      # ```
      #     property :attr_name, as: 'attrName'
      # ```
      def property(name, options = {}, &block)
        add_declaration(name, options, :property, block)
      end

      # Define a collection using 'attr_name', defaults class to `OpenStruct`
      def collection(name, options = {}, &block)
        add_declaration(name, options, :collection, block)
      end

      def representer_class
        @representer_class ||= if constants.include?(:Representer)
                                 const_get(:Representer)
                               else
                                 send(:dynamically_create_representer)
                               end
      end

      def from_hash(hash)
        representer_class.new(new).from_hash(hash)
      end

      def as_json(*args)
        representer_class.new(self).as_json(*args)
      end

      def declarations
        @declarations ||= {}
      end

      private

      def add_declaration(name, options, method, block)
        decl = Declaration.new(name, options, method)
        decl.instance_eval(&block) if block
        declarations[name] = decl
        attr_accessor name
      end

      # The ff. methods are private to avoid explicit calling. This is why we have to
      # send(:method_name) throughout

      def dynamically_create_representer
        # `this` here is the Resource class
        this = self
        representer_class = Class.new(Representable::Decorator) do
          include Representable::JSON
          include Representable::Hash
          include Representable::Hash::AllowSymbols
          # self here is the new class being dynamically declared
          this.send(:dynamically_declare_mappings, this, self)
        end
        this.const_set(:Representer, representer_class)
      end

      def dynamically_declare_mappings(resource, representer)
        resource.declarations.each do |_name, decl|
          decl.declare_mappings(resource, representer)
        end
      end
    end

    def initialize(params = {})
      params.each do |attr, value|
        send("#{attr}=", value)
      end
    end

    def representer_class
      @representer_class ||= self.class.representer_class
    end

    def to_json
      representer_class.new(self).to_json
    end

    def to_s
      data = self.class.declarations.values.map do |decl|
        attr = decl.name
        v = send(attr)
        next unless v
        vv = v.is_a?(String) ? v.inspect : v.to_s
        "#{attr}: #{vv}"
      end.compact.join(' ')
      "<#{self.class}:0x#{format('%014x', object_id << 1)} #{data}>"
    end

    # A `property` or `collection` declaration
    class Declaration
      attr_reader :name, :options, :method

      def initialize(name, options, method)
        @name = name
        @options = options
        @method = method
        @options[:as] = name.to_s.camelcase(:lower) unless @options.key?(:as)
        @poc_declarations = {}
      end

      def attributes(*args)
        unless args.empty?
          props = args.first.is_a?(Array) ? args.first : args
          props.each { |attr| property attr.to_sym }
        end
        @poc_declarations.keys
      end

      alias properties attributes

      def property(name, options = {}, &block)
        prop = Declaration.new(name, options, :property)
        prop.instance_eval(&block) if block_given?
        @poc_declarations[name] = prop
      end

      def collection(name, options = {}, &block)
        coll = Declaration.new(name, options, :collection)
        coll.instance_eval(&block) if block_given?
        @poc_declarations[name] = coll
      end

      def declare_mappings(resource, representer)
        # Add coercion if needed
        representer.send(:include, Representable::Coercion) if options[:type]
        do_declare_mappings(resource, representer, method)
      end

      # rubocop:disable Metrics/AbcSize
      def do_declare_mappings(resource, representer, method)
        # rubocop:enable Metrics/AbcSize
        if options.key?(:class) && options[:class] < Expedia::Resource
          clazz = options[:class]
          representer.send(method, name, options) do
            clazz.send(:dynamically_declare_mappings, clazz, self)
          end
        else
          declarations = @poc_declarations
          if declarations.empty?
            representer.send(method, name, options)
          else
            options[:class] = OpenStruct unless options.key?(:class)
            representer.send(method, name, options) do
              this = self
              declarations.each do |_name, decl|
                decl.declare_mappings(resource, this)
              end
            end
          end
        end
      end
    end
  end
end
