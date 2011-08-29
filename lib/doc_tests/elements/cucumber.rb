module DocTests
  module Elements
    class Cucumber < DocTests::Element
      def self.tag
        :doc
      end
      def self.matches?(full_document)
        true
      end
      
      def preprocess
        before_feature
        before_scenario
      end
      
      def postprocess
        after_scenario
        after_feature
      end
      
      # TODO
      def before_feature
        
      end
      def before_scenario
        
      end
      
      def after_scenario
        
      end
      def after_feature
        
      end
    end
  end
end