require "cucumber/ast/step_invocation"
require "cucumber/ast/step"
require "cucumber/ast/doc_string"
require "cucumber/step_match"
require "gherkin/rubify"


module DocTests
  module Stepper
    class Rubifier
      include ::Gherkin::Rubify
      
    end
    
    def self.visit_step(visitor, step, collection, scenario)
      step.step_collection = collection
      step.feature_element = scenario
      step.gherkin_statement(::Gherkin::Formatter::Model::Step.new([], step.keyword, step.name, step.line, nil, nil))
      step_invocation = step.step_invocation
      step_invocation.step_collection = collection
      collection.add_step_invocation(step_invocation)
      visitor.visit_step(step_invocation)
    end
    
    def self.visit_block(visitor, counter, name, collection, scenario, block)
      step = BlockStep.new(counter, name, block)
      visit_step(visitor, step, collection, scenario)
    end
    
    def self.visit_text(visitor, counter, text, collection, scenario)
      multiline_arg = nil
      lines = text.split("\n")
      text = lines.shift
      if lines.length > 1
        multi = lines.join("\n")
        puts multi[0,3]
        puts  multi[-3,3]
        if multi[0,3] == '"""' and multi[-3,3] == '"""'
          multi = multi[3..-4]
          puts multi
        end
        multiline_arg = ::Cucumber::Ast::DocString.new(multi)
      end
      
      parts = text.split(" ")
      keyword = parts.shift # e.g. Given
      name = parts.join(" ")

      step = ::Cucumber::Ast::Step.new(counter, keyword+ " ", name, multiline_arg)
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
        @step_match = BlockMatch.new(@step)
        step_mother.step_visited(self)
      end
    end
    
    class BlockStep < ::Cucumber::Ast::Step
      def initialize(counter, name, block)
        # super(line, keyword, name, multiline_arg=nil)
        super(counter, "", name)
        @block = block
      end
      
      def step_invocation
        BlockInvocation.new(self, @name, @multiline_arg, [])
      end
      
      def call
        @block.call
      end
    end
  end
end