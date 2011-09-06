require 'nokogiri'

module DocTests
  module Parsers
    extend self
        
    def xml_to_hash(html)
      doc = Nokogiri::XML(html)
      doc.to_hash
    end
    
    def xml_to_request_data(xml)
      xml
    end
    
  end
end