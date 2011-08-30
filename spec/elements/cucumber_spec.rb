require "spec_helper"

module DocTests
  describe Elements::Cucumber do
    before(:each) do
      @runtime = Cucumber::Runtime.new
    
      @runtime.load_programming_language('rb')
      @dsl = Object.new
      @dsl.extend(::Cucumber::RbSupport::RbDsl)
    
      @dsl.Given(/^we have cucumber support$/) do
        @cucumber = true
      end
      @dsl.Then(/^my steps get called$/) do
        @cucumber = true
      end
    
      @visitor = ::Cucumber::Ast::TreeWalker.new(@runtime)
      Config.stubs(:elements).returns([Elements::Cucumber])
    end
  end
end