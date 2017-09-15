# frozen_string_literal: true

# The XmlMapper 'namespace'
module XmlMapper
  # An XmlResource mixin
  module XmlResource
    extend ActiveSupport::Concern
    class_methods do
      def root_element
        @element ||= ElementDeclaration.new
      end

      def tag(*args)
        root_element.name = name if args.first.is_a?(Symbol) || args.first.is_a?(String)
        root_element.name
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

      def has_many(name, options = {}, &block)
        root_element.has_many(name, options, &block)
        attr_accessor name
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

  ElementDeclaration = Struct.new(:name, :allow_multiple, :options, :block) do

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

    def has_many(name, options = {}, &block)
      element name, options.merge(allow_multiple: true), &block
    end

    def collection

    end

    def perform_mapping(obj, node)
      attributes.each do |attr|
        puts %{#{obj}.send("#{attr.name}=", #{node[attr.name]})"}
        obj.send("#{attr.name}=", node[attr.name])
      end
      children.each do |child|
        p child
        as = child.options[:as] || child.options[:class] ? child.options[:class].to_s.demodulize : child.name.to_s.camelcase
        child_node = node.at(as)
        p child_node
        clazz = child.options[:class] || OpenStruct
        child_obj = (clazz == OpenStruct ? OpenStruct.new : clazz.new)
        if child_obj.is_a?(XmlResource)
          child_obj.from_node(child_node)
        else
          child.perform_mapping(child_obj, child_node)
        end
        puts %{#{obj}.send("#{child.name}=", #{child_obj})}
        obj.send("#{child.name}=", child_obj)
      end
      puts "obj => #{obj.inspect}"
      obj
    end
  end
end
