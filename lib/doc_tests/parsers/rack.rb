module DocTests
  module Parsers
    class RackHeaderTester < Tester
      def initialize(rack)
        @rack = rack
      end
      def test(header, value)
        @rack.last_response.headers[header].should == value
      end
    end
    
    extend self

    def rack_status_code_to_string(rack)
      rack.status_code.to_s
    end
    
    def rack_content_type_to_string(rack)
      rack.response.content_type.split(";").first
    end
    
    def rack_header_value_to_tester(rack)
      RackHeaderTester.new(rack)
    end
    
    def rack_response_to_response_data(data)
      # best completely generic comparision I can think of it to just remove whitespace
      #data.to_s.gsub(/\s+/, "")
      data
    end
  end
end