# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'representable'

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
          f = args.first
          f.each { |attr| property attr.to_sym } if f.is_a?(Array)
        end
        properties.keys + collections.keys
      end

      # Define a property using 'attr_name', equivalent to
      #
      # ```
      #     property :attr_name, as: 'attrName'
      # ```
      def property(name, options = {}, &block)
        prop = Declaration.new(name, options, :property)
        prop.instance_eval(&block) if block_given?
        properties[name] = prop
        attr_accessor name
      end

      # Define a collection using 'rawName', defaults to `OpenStruct`
      def collection(name, options = {}, &block)
        coll = Declaration.new(name, options, :collection)
        coll.instance_eval(&block) if block_given?
        collections[name] = coll
        attr_accessor name
      end

      def properties
        @properties ||= {}
      end

      def collections
        @collections ||= {}
      end

      private

      # The ff. methods are private, to avoid explicit calling. This is why we have to
      # send(:method_name) throughout

      def dynamically_create_representer
        puts "#{self}#dynamically_create_representer"
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
        puts "dynamically_declare_mappings(#{resource}, #{representer})"
        map_simple_properties(resource, representer)
        map_collections(resource, representer)
      end

      def map_simple_properties(resource, representer)
        puts "map_simple_properties(#{resource}, #{representer})"
        resource.properties.each do |_name, prop|
          puts "prop => #{prop.inspect}"
          prop.declare_mappings(resource, representer)
        end
      end

      def map_collections(resource, representer)
        puts "map_collections(#{resource}, #{representer})"
        resource.collections.each do |_name, coll|
          puts "coll => #{coll.inspect}"
          coll.declare_mappings(resource, representer)
        end
      end
    end

    class << self
      def from_hash(hash)
        representer_class = if constants.include?(:Representer)
                              const_get(:Representer)
                            else
                              send(:dynamically_create_representer)
                            end
        puts "representer_class => #{representer_class}"
        representer_class.new(new).from_hash(hash)
      end
    end

    def to_s
      data = self.class.properties.values.map do |prop|
        attr = prop.name
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
        do_declare_mappings(resource, representer, method)
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def do_declare_mappings(resource, representer, method)
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize
        if options.key?(:class)
          clazz = options[:class]
          if clazz < Expedia::Resource
            representer.send(method, name, options) do
              clazz.send(:dynamically_declare_mappings, clazz, self)
            end
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
