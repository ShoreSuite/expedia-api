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
end
