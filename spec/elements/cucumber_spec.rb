require "spec_helper"

describe DocTests::Elements::Cucumber do
  before(:each) do
    @runtime = DocTests::Cucumber::Runtime.new
    
    @runtime.load_programming_language('rb')
    @dsl = Object.new
    @dsl.extend(Cucumber::RbSupport::RbDsl)
    
    @dsl.Given(/^we have cucumber support$/) do
      @cucumber = true
    end
    @dsl.Then(/^my steps get called$/) do
      @cucumber = true
    end
    
    @visitor = ::Cucumber::Ast::TreeWalker.new(@runtime)
    DocTests::Config.stubs(:elements).returns([DocTests::Elements::Cucumber])
  end
end