require 'cucumber/ast/scenario'
require 'cucumber/ast/step_collection'

module DocTests
  class Markdown < ::Cucumber::Ast::Scenario
    class Collection < ::Cucumber::Ast::StepCollection
      def initialize(markdown)
        @markdown = markdown
        super([]) # no known steps at this time
      end
      def accept(visitor, &proc)
        return if ::Cucumber.wants_to_quit
        ::Redcarpet::Markdown.new(Dispatch.new(self, visitor)).render(content)
      end
      def markdown
        @markdown
      end
      def content
        markdown.content
      end
    end
    class Background
      def initialize(markdown)
        @markdown = markdown
      end
      def failed?
        false
      end
      
      def feature_elements
        []
      end
      
      def step_collection(step_invocations)
        Collection.new(@markdown)
      end
      
      def init
      end
    end
      
    def initialize(content)
      @content = content
      # self.feature set to parent document
      
      # super(background, comment, tags, line, keyword, title, description, raw_steps)
      super(Background.new(self),
            ::Cucumber::Ast::Comment.new("Scenario Comment"), 
            ::Cucumber::Ast::Tags.new(nil, []), 
            1,
            "Scenario Keyword", 
            "Scenario Title",
            "Scenario Decscription",
            []
          )
      #init
    end
  
    def content
      @content
    end
  end
end