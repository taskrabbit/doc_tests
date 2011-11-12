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
        201 => "Created",
        202 => "Accepted",
        203 => "Non-Authoritative Information",
        204 => "No Content",
        205 => "Reset Content",
        206 => "Partial Content",
        300 => "Multiple Choices",
        301 => "Moved Permanently",
        302 => "Found Moved Temporarily",
        303 => "See Other",
        304 => "Not Modified",
        305 => "Use Proxy",
        306 => "(Unused)",
        307 => "Temporary Redirect",
        400 => "Bad Request",
        401 => "Unauthorized",
        402 => "Payment Required",
        403 => "Forbidden",
        404 => "Not Found",
        405 => "Method Not Allowed",
        406 => "Not Acceptable",
        407 => "Proxy Authentication Required",
        408 => "Request Timeout",
        409 => "Conflict",
        410 => "Gone",
        411 => "Length Required",
        412 => "Precondition Failed",
        413 => "Request Entity Too Large",
        414 => "Request-URI Too Long",
        415 => "Unsupported Media Type",
        416 => "Requested Range Not Satisfiable",
        417 => "Expectation Failed",
        422 => "Unprocessable Entity",
        500 => "Internal Server Error",
        501 => "Not Implemented",
        502 => "Bad Gateway",
        503 => "Service Unavailable",
        504 => "Gateway Timeout",
        505 => "HTTP Version Not Supported"
      }
  
      def self.parse_code(text)
        pieces = text.split(" ")
        return nil unless pieces.size >= 2
        code = pieces.shift.to_i
        val = CODES[code]
        return nil unless val
        return nil unless val.downcase == pieces.join(" ").downcase
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
          if pieces[0].downcase == "compare"
            @response_compare = pieces[1]
          else
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
          method = @response_compare || DocTests::Config.response_compare
          set = Set.new(DocTests::Config.excluded_keys)
          hash1 = Differ.exclude_keys(hash1, set)
          hash2 = Differ.exclude_keys(hash2, set)
          Differ.send("#{method.to_s.downcase.strip}!", hash1, hash2)
        end
      end
      
    end
  
    class Differ
      
      SKIP_MATCHER    = "^<<.*>>$"
      BETWEEN_MATCHER = '%{BETWEEN ([\d\.]+) AND ([\d\.]+)}'

      def self.exclude_keys(obj, keys)
        if obj.is_a? Hash
          out = {}
          obj.each do |key, value|
            out[key] = exclude_keys(obj[key], keys) unless keys.include?(key.to_s)
          end
          out
        elsif obj.is_a? Array
          out = []
          obj.each do |value|
            out <<  exclude_keys(value, keys)
          end
          out
        else
          obj
        end
      end
      
      def self.skip?(value)
        value =~ /#{SKIP_MATCHER}/
      end
      
      def self.between?(value, returned_value)
        if value =~ /#{BETWEEN_MATCHER}/
          $1.to_f <= returned_value.to_f and returned_value.to_f <= $2.to_f
        end
      end
      
      def self.evaluated_value?(value, returned_value)
        skip?(value) or between?(value, returned_value)
      end
      
      def self.equal!(needles, haystack)
        haystack.should == needles
      end
      
      def self.include!(needles, haystack)
        errors = include_check(needles, haystack)
        
        bad = []
        errors.each do |error_hash|
          if error_hash[:message]
            bad << "#{error_hash[:key]} #{error_hash[:message]}"
          else
            # value check
            unless DocTests::Equivalency.key_values?(error_hash[:key], error_hash[:expected], error_hash[:got])
              bad << "#{error_hash[:key]} is not equal\nexpected: #{error_hash[:expected].inspect}\ngot: #{error_hash[:got].inspect}"
            end
          end
        end
        
        raise bad.join("\n") unless bad.empty?
      end
      
      def self.include_check(needles, haystack)
        errors = []
        
        if haystack.is_a? Hash and needles.is_a? Hash
         needles.each do |key, value|
           if not haystack.has_key?(key)
             errors << {:key => key.to_s, :messsage => "not found!"}
           else
             include_check(value, haystack[key]).each do |error|
               if error[:key].nil?
                 error[:key] = key.to_s
               else
                 error[:key] = key.to_s + "/" + error[:key]
               end
               errors << error
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
              errors << {:key => "item", :message => "not found in list.\nvalue: #{n_value.inspect}\nwithin: #{haystack.inspect}"}
            end
          end
        elsif !evaluated_value?(needles, haystack) and needles != haystack
          errors << {:key => nil, :expected => needles, :got => haystack}
        end

        errors
      end
    end
  end
end