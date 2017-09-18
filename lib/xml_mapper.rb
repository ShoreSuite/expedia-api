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
end

require 'xml_mapper/element_declaration'
require 'xml_mapper/xml_resource'
