require 'cucumber/ast/feature'

module DocTests
  class Document < ::Cucumber::Ast::Feature
    attr_accessor :file_name
    def initialize(file_name)
      self.file_name = file_name
      # super(background, comment, tags, keyword, title, description, feature_elements)
      super(nil, 
          ::Cucumber::Ast::Comment.new("Feature Comment"), 
          ::Cucumber::Ast::Tags.new(nil, []), 
          "Feature Keyword",
          "Feature Title",
          "Feature Descrption",
          markdowns
        )
    end
    
    def content
      File.read(file_name)
    end
    
    def markdowns
      [Markdown.new(content)]
    end
    
#    def accept(visitor)
#      return if ::Cucumber.wants_to_quit
#      
#      visitor.visit_feature_name(file_name, indented_name)
#      # TODO? visitor.visit_tags(tags)
#      visitor.visit_feature_element(Markdown.new(self, content))
#    end
    
#    def indented_name
#      "   #{file_name}"
#    end
  end
end