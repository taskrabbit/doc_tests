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
        return false unless text
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
      
      def get_response_parser(language)
        try = []
        try << language
        
        content_type = DocTests::Parsers.rack_content_type_to_string(rack)
        if content_type
          try << content_type
          pieces = content_type.split("/")
          try << pieces.last if pieces.size > 1
        end
        
        try << "Rack Response"
        Parser.new(try, ["Hash"])
      end
      
      def block_code(code, language)
        to_hash = get_response_parser(language)
        hash1 = to_hash.visit(parent, code)
        hash2 = to_hash.visit(parent, rack.response.body)
        parent.visit_block("Response Verification") do
          Differ.include!(hash1, hash2)
        end
      end
      
    end
  
    class Differ    
      def self.equal!(needles, haystack)
        haystack.should == needles
      end
      
      def self.include!(needles, haystack)
        errors = include_check(needles, haystack)
        raise errors.join("\n") unless errors.empty?        
      end
      
      def self.include_check(needles, haystack)
        errors = []
        
        if haystack.is_a? Hash and needles.is_a? Hash
         needles.each do |key, value|
           if not haystack.has_key?(key)
             errors << "/#{key} not found!"
           else
             include_check(value, haystack[key]).each do |error|
               errors << "/#{key}#{error}"
             end
           end
         end
        elsif haystack.is_a? Array and needles.is_a? Array
          copy = haystack.clone
          needles.each do |n_value|
            found = -1
            copy.each_with_index do |h_value, i|
              if include_check(n_value, h_value).size == 0
                found = i
                break
              end
            end
            if found >= 0
              copy.delete_at(found)
            else
              errors << "/item not found in list.\nvalue: #{n_value.inspect}\nwithin: #{haystack.inspect}"
            end
          end
        elsif needles != haystack
          errors << " is not equal\nexpected: #{needles.inspect}\ngot: #{haystack.inspect}"
        end

        errors
      end
    end
  end
end