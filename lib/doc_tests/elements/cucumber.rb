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
      
      def list_item(text, list_type)
        run_step!(text)
      end
      
      def run_step!(text)
        parent.visit_text(text)
      end
    end
  end
end