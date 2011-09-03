module DocTests
  module Elements
    class Response < DocTests::Element
      def self.tag
        :h3
      end
      
      def self.matches?(text, level)
        return false unless level == 3
        return true if !(text =~ /response/i).nil?
        !parse_code(text).nil?
      end
      
      CODES = {
        200 => "OK",
        201 => "Created"
      }
      
      def self.parse_code(text)
        pieces = text.split(" ")
        return nil unless pieces.size == 2
        code = pieces[0].to_i
        val = CODES[code]
        return nil unless val
        return nil unless val.downcase == pieces[1].downcase
        [code, val]
      end
      
      def rack
        Request.rack
      end
      
      def execute_code(tuple)
        return if tuple.nil?
        code, val = tuple
        parent.visit_block("Response: #{code} #{val}") do
          rack.status_code.should == code
        end
      end
      
      def header(text, level)
        return unless level == 3
        execute_code(self.class.parse_code(text))
      end
      
      def before_list_item?(text, type)
        return true if @in_list
        text.split(":").size == 2
      end
      
      def list_item(text, type)
        @in_list = true
        
        pieces = text.split(":")
        if pieces.size == 2
          p = Parser.new(["Rack #{pieces[0]}", "Rack Header Value"], ["tester", "string"])
          check = p.visit(parent, rack)
          parent.visit_block("Response Property -> #{text.strip}") do
            value = pieces[1].strip
            if check.is_a? Parsers::Tester
              check.test(pieces[0],value)
            else
              check.should == value
            end
          end 
        elsif @in_list
          parent.visit_block("Response Property -> #{text.strip}") do
            raise "#{text} is an invalid response property. Example... Content-Type: text/html"
          end
        end
      end
      
      def list(content, type)
        @in_list = false
      end
      
    end
  end
end