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
      
      def before(visitor)
        @visitor = visitor
      end
      
      def list_item(text, list_type)
        @counter ||= 1
        run_step!(@counter, text)
        @counter += 1
      end
      
      def run_step!(counter, text)
        parts = text.split(" ")
        keyword = parts.shift # e.g. Given
        name = parts.join(" ")
        
        step = ::Cucumber::Ast::Step.new(counter, keyword, name)
        step_invocation = step.step_invocation
        step_collection = ::Cucumber::Ast::StepCollection.new([step_invocation])
        step_invocation.invoke(@visitor.step_mother, @visitor.configuration)
        
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
  end
end