require 'nokogiri'

# Convert an XML or HTML document to a Hash
# Adapted from: 
# => https://github.com/FestivalBobcats/Nokogiri-Hash-Patch
# => https://github.com/kuroir/Nokogiri-to-Hash
module Nokogiri::XML
  
  class Document
    def to_hash
      self.root.to_hash
    end
  end
  
  class Node
    
    def attributes_to_hash
      attrs = {}
      self.attributes.each do |name, value|
        attrs[name] = value.to_s
      end
      attrs
    end
    
    def children_to_hash
      arr = []
      self.children.each do |child|
        hash = {}
        if child.name == "text"
          arr << child.text.strip if child.text.strip.length > 0
        else
          arr << child.to_hash
        end
      end
      {:children => arr}  
    end
  
    def to_hash
      attrs = {}
      attrs.merge!(attributes_to_hash)
      attrs.merge!(children_to_hash) if self.children.size > 0
      { self.name => attrs }
    end
      
  end
  
end