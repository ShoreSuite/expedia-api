# frozen_string_literal: true

# The XmlMapper 'namespace'
module XmlMapper
  # An XmlResource mixin
  module XmlResource
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/BlockLength
    class_methods do
      # rubocop:enable Metrics/BlockLength
      def root_element
        @element ||= ElementDeclaration.new
      end

      def tag(name)
        root_element.name = name
      end

      def attributes(*args)
        unless args.empty?
          a = args.first.is_a?(Array) ? args.first : args
          a.each { |s| attribute s }
        end
        root_element.attributes
      end

      def attribute(name, options = {})
        root_element.attribute(name, options)
        attr_accessor name
      end

      delegate :children, to: :root_element
      def element(name, options = {}, &block)
        root_element.element(name, options, &block)
        attr_accessor name
      end

      # rubocop:disable Style/PredicateName
      def has_many(name, options = {}, &block)
        # rubocop:enable Style/PredicateName
        child = root_element.has_many(name, options, &block)
        attr_accessor child.setter_name
      end

      def from_node(node)
        new.tap { |obj| obj.from_node(node) }
      end
    end

    def initialize(*args)
      self.class.attributes.zip(args).each do |attr, v|
        send("#{attr.name}=", v)
      end
    end

    def from_node(node)
      self.class.root_element.perform_mapping(self, node)
      self
    end
  end

  AttributeDeclaration = Struct.new(:name, :options)

  # rubocop:disable Metrics/BlockLength
  ElementDeclaration = Struct.new(:name, :allow_multiple, :options, :block) do
    # rubocop:enable Metrics/BlockLength
    def attributes(*args)
      @attributes ||= []
      unless args.empty?
        a = args.first.is_a?(Array) ? args.first : args
        a.each { |s| attribute s }
      end
      @attributes
    end

    def children
      @children ||= []
    end

    def attribute(name, options = {})
      attributes << AttributeDeclaration.new(name, options)
    end

    def element(name, options = {}, &block)
      allow_multiple = options.delete(:allow_multiple)
      ElementDeclaration.new(name, allow_multiple, options).tap do |element|
        element.instance_eval(&block) if block_given?
        children << element
      end
    end

    # rubocop:disable Style/PredicateName
    def has_many(name, options = {}, &block)
      # rubocop:enable Style/PredicateName
      element name, options.merge(allow_multiple: true), &block
    end

    # TODO: Simplify this
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def perform_mapping(obj, node)
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize
      attributes.each do |attr|
        xml_attr_name = attr.options[:as] || attr.name
        obj.send("#{attr.name}=", node[xml_attr_name])
      end
      children.each do |child|
        tag = child.options[:tag] || if child.options[:class]
                                       child.options[:class].to_s.demodulize
                                     else
                                       child.name.to_s.camelcase
                                     end
        value = if child.allow_multiple
                  child_nodes = node.css(tag)
                  child_nodes.map do |child_node|
                    obj_from_child_node(child, child_node)
                  end
                else
                  # single
                  child_node = node.at(tag)
                  obj_from_child_node(child, child_node)
                end
        obj.send("#{child.setter_name}=", value)
      end
      obj
    end

    def setter_name
      options[:as] || allow_multiple ? name.to_s.pluralize : name
    end

    private

    def obj_from_child_node(child, child_node)
      clazz = child.options[:class] || OpenStruct
      child_obj = (clazz == OpenStruct ? OpenStruct.new : clazz.new)
      if child_obj.is_a?(XmlResource)
        child_obj.from_node(child_node)
      else
        child.perform_mapping(child_obj, child_node)
      end
      child_obj
    end
  end
end
