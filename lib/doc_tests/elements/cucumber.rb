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
        if not @in_list and not @matching and self.class.step?(text)
          @matching = true
          run_step!(text)
        end
        @in_list = true
      end
      
      def normal_text(text)
        run_step!(text) if @matching
      end
      
      def list(contents, list_type)
        # done with the list
        @in_list = false
        @matching = false
      end
      
      def run_step!(text)
        return if not text or text.strip.length == 0
        parent.visit_text(text)
      end
    end
  end
end