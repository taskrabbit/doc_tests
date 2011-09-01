require 'cucumber/ast/feature'

module DocTests
  class Document < ::Cucumber::Ast::Feature
    def self.calc_name(file_name)
      # TODO: just the file name (not including path)?
      file_name || "Document"
    end
    
    attr_accessor :file_name
    def initialize(file_name)
      self.file_name = file_name
      # super(background, comment, tags, keyword, title, description, feature_elements)
      super(nil, 
          ::Cucumber::Ast::Comment.new(""), 
          ::Cucumber::Ast::Tags.new(nil, []), 
          "Feature",
          Document.calc_name(file_name),
          "",
          markdowns
        )
      self.language = ::Gherkin::I18n.get('en')
      self.file = file_name
      gherkin_statement(::Gherkin::Formatter::Model::Feature.new([], [], @keyword, @name, @description, 1))
    end
    
    def content
      File.read(file_name)
    end
    
    def markdowns
      # split by horizontal rules
      pieces = content.split(/^\s*(?:[*-]\s?){3,}\s*$/)
      pieces.reject!{ |c| c.strip.length == 0 }
      pieces.collect{ |c| Markdown.new(c) }
    end
    
  end
end