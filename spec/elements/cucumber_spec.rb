require "spec_helper"

describe DocTests::Elements::Cucumber do
  before(:each) do
    runtime = DocTests::Elements::Cucumber.runtime
    runtime.load_programming_language('rb')
    @dsl = Object.new
    @dsl.extend(Cucumber::RbSupport::RbDsl)
    
    @dsl.Given(/^we have cucumber support$/) do
      @cucumber = true
    end
    @dsl.Then(/^my steps get called$/) do
      @cucumber = true
    end
    
    DocTests::Config.stubs(:elements).returns([DocTests::Elements::Cucumber])
  end
  
  describe "Cucumber hooks" do
    it "should be called before and after document parsing" do
      DocTests::Elements::Cucumber.any_instance.expects(:before_scenario)
      DocTests::Elements::Cucumber.any_instance.expects(:after_scenario)
            
      doc = DocTests::Config.document("cuke.mdown")
      doc.parse!
    end
  end
end