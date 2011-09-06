require 'nokogiri'

module DocTests
  module Parsers
    extend self
        
    def html_to_hash(html)
      doc = Nokogiri::HTML(html)
      doc.to_hash
    end
  end
end