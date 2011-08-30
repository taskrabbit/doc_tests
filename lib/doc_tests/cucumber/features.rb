require 'cucumber/ast/features'

module DocTests
  class Features < ::Cucumber::Ast::Features
    def initialize(files)
      @features = files.collect { |f| DocTests::Document.new(f) }
    end
  end
end