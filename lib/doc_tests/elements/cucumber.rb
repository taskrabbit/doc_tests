require 'cucumber'

module DocTests
  module Elements
    class CucumberRuntime < ::Cucumber::Runtime
      attr_reader :support_code
      attr_reader :configuration
      attr_reader :tree_walker
            
      def new
        super
        support_code.fire_hook(:after_configuration, configuration)
      end
      
      def run_step!(counter, text)
        parts = text.split(" ")
        keyword = parts.shift # e.g. Given
        name = parts.join(" ")
        
        step = ::Cucumber::Ast::Step.new(counter, keyword, name)
        step_invocation = step.step_invocation
        step_collection = ::Cucumber::Ast::StepCollection.new([step_invocation])
        step_invocation.invoke(self, configuration)
        
        # [:passed, :undefined, :pending, :skipped, :failed]
        case step_invocation.status
          when :undefined
            raise "Cucumber step not defined: #{text}"
          when :failed
            ex = step_invocation.reported_exception || step_invocation.exception
            raise "Cucumber step failed: #{text}\n\n#{ex.message}"
        end
      end
    end
    
    class Cucumber < DocTests::Element
      def self.tag
        :doc
      end
      def self.matches?(full_document)
        true
      end
      
      def self.runtime
        return @runtime if @runtime 
        @runtime = CucumberRuntime.new
      end
            
      def preprocess(full_document)
        @runtime = self.class.runtime
        @feature = create_feature(full_document)
        @scenario = create_scenario(full_document)
        before_scenario
      end
      
      def postprocess(full_document)
        after_scenario
      end
      
      def list_item(text, list_type)
        @counter ||= 1
        @runtime.run_step!(@counter, text)
        @counter += 1
      end
      
      
      def create_feature(doc)
        # Feature.new(background, comment, tags, keyword, title, description, feature_elements -- such as scenario)
        ::Cucumber::Ast::Feature.new(
          nil,
          ::Cucumber::Ast::Comment.new("Feature Comment"),
          ::Cucumber::Ast::Tags.new(nil, []),  
          "Feature Keyword", 
          "Feature Title",
          "Feature Description",
          []
        )
      end
      
      def create_scenario(doc)
        # Scenario.new(background, comment, tags, line, keyword, title, description, raw_steps)
        ::Cucumber::Ast::Scenario.new(
          nil,
          ::Cucumber::Ast::Comment.new("Scenario Comment"), 
          ::Cucumber::Ast::Tags.new(nil, []), 
          1,
          "Scenario Keyword", 
          "Scenario Title",
          "Scenario Decscription",
          []
        )
      end
      
      def before_scenario
        @runtime.before(@scenario)
      end
      
      def after_scenario
        @runtime.after(@scenario)
      end

      def after_step
        @runtime.after_step
      end

    end
  end
end