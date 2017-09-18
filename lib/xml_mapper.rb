# frozen_string_literal: true

# The XmlMapper 'namespace'
module XmlMapper
  class << self
    attr_writer :auto_camelize_element_names
    def auto_camelize_element_names
      @auto_camelize_element_names ||= true
    end
    attr_writer :auto_camelize_attribute_names
    def auto_camelize_attribute_names
      @auto_camelize_attribute_names ||= true
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

    def setter_name
      options[:as] || (allow_multiple ? name.to_s.pluralize : name)
    end

    # Magic happens here
    def perform_mapping(obj, node)
      map_attributes(node, obj)
      map_child_nodes(node, obj)
      obj
    end

    def tag_name
      options[:tag] || if options[:class]
                         options[:class].to_s.demodulize
                       else
                         XmlMapper.auto_camelize_element_names ? name.to_s.camelcase : name.to_s
                       end
    end

    private

    def map_child_nodes(node, obj)
      children.each do |child|
        tag = child.tag_name
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
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/PerceivedComplexity
    def map_attributes(node, obj)
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/AbcSize
      attributes.each do |attr|
        xml_attr_name = attr.options[:as] || if XmlMapper.auto_camelize_attribute_names
                                               attr.name.to_s.camelize(:lower)
                                             else
                                               attr.name.to_s
                                             end
        xml_attr_val = node[xml_attr_name]
        next unless xml_attr_val
        val = if attr.options.key?(:type)
                if [Integer, :integer, :int].include?(attr.options[:type])
                  xml_attr_val.to_i
                else
                  xml_attr_val
                end
              else
                xml_attr_val
              end
        obj.send("#{attr.name}=", val)
      end
    end

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

require 'xml_mapper/xml_resource'
