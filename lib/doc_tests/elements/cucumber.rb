require 'cucumber'

module DocTests
  module Elements
    class Cucumber < DocTests::Element
      def self.tag
        :doc
      end
      def self.matches?(full_document)
        true
      end
      
      def self.step?(text)
        !(text =~ /^\s*(Given|When|Then|And) \S+/i).nil?
      end
      
      def list_item(text, list_type)
        return if text.nil?
        text = text.strip
        return if text.length == 0
        
        if not @in_list and not @matching
          @matching = self.class.step?(text)
        end
        
        if @matching
          run_step!(text)
        elsif @keyword
          run_step!("#{@keyword} #{text[0,1].downcase}#{text[1..-1]}")
        end
        
        @in_list = true
      end
      
      def list(contents, list_type)
        # done with the list
        @in_list = false
        @matching = false
      end
      
      def header(text, level)
        @keyword = nil
        check = DocTests::Config.cucumber_headers || {}
        check.each do |keyword, array|
          array.each do |word|
            if text.strip == word
              @keyword = keyword.to_s.capitalize
              break
            end
          end
        end
      end
      
      def run_step!(text)
        parent.visit_text(text)
      end
    end
  end
end