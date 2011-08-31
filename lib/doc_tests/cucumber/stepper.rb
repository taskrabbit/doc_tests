require "cucumber/ast/step_invocation"
require "cucumber/ast/step"
require "cucumber/step_match"

module DocTests
  module Stepper
    def self.visit_step(visitor, step, collection, scenario)
      step.step_collection = collection
      step.feature_element = scenario
      step_invocation = step.step_invocation
      step_invocation.step_collection = collection
      collection.add_step_invocation(step_invocation)
      visitor.visit_step(step_invocation)
    end
    
    def self.visit_block(visitor, counter, name, collection, scenario, &block)
      step = BlockStep.new(counter, name, block)
      visit_step(visitor, step, collection, scenario)
    end
    
    def self.visit_text(visitor, counter, text, collection, scenario)
      parts = text.split(" ")
      keyword = parts.shift # e.g. Given
      name = parts.join(" ")

      step = ::Cucumber::Ast::Step.new(counter, keyword+ " ", name)
      visit_step(visitor, step, collection, scenario)
    end
    
    class BlockMatch < ::Cucumber::StepMatch
      def initialize(step)
        @step = step
        # super(step_definition, name_to_match, name_to_report, step_arguments)
        super(@step, "name to match", "" + @step.name, [])
      end
      
      def invoke(multiline_arg)
        @step.call
      end
    end
    class BlockInvocation < ::Cucumber::Ast::StepInvocation
      def find_step_match!(step_mother, configuration)
        return if @step_match
        @step_match = Match.new(@step)
        step_mother.step_visited(self)
      end
    end
    
    class BlockStep < ::Cucumber::Ast::Step
      def initialize(counter, name, block)
        # super(line, keyword, name, multiline_arg=nil)
        super(counter, "", name)
      end
      
      def step_invocation
        Invocation.new(self, @name, @multiline_arg, [])
      end
      
      def call
        block.call
      end
    end
  end
end