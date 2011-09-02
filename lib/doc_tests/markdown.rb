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
        Redcarpet::Markdown.new(Dispatch.new(self, visitor), Config.render_options).render(content)
      end
      def markdown
        @markdown
      end
      def content
        markdown.content
      end
      def add_step_invocation(si)
        @steps << si
      end
      def step_count
        @steps.size
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
            ::Cucumber::Ast::Comment.new(""), 
            ::Cucumber::Ast::Tags.new(nil, []), 
            1,
            "Scenario", 
            content_options[:title],
            content_options[:description],
            []
          )
      gherkin_statement(::Gherkin::Formatter::Model::Scenario.new([], [], @keyword, @name, @description, @line))
    end
    
    def step_count
      return 0 unless @steps
      @steps.step_count
    end
  
    def content_options
      return @content_options if @content_options
      @content_options = Markdown.content_options(content)
    end
  
    def content
      @content
    end
    
    def self.content_options(content)
      parser = OptionParser.new
      Redcarpet::Markdown.new(parser).render(content)
      parser.options
    end
    
    class OptionParser < Redcarpet::Render::Base
      def for_title(text, level)
        @title_level ||= 100
        if level < @title_level
          text ||= ""
          lines = text.split("\n")
          lines.each do |line|
            line = line.strip
            if line.length > 0
              @title_level = level
              @title = line
            end
            break
          end
        end
        text
      end
      def header(text, level)
        for_title(text, level)
      end
      def normal_text(text)
        for_title(text, 10)
      end
      
      def options
        {
          :title => @title || "",
          :description => @description || ""
        }
      end
    end
  end
end