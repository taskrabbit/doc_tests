require "spec_helper"

module DocTests
  class Note
    def called
      
    end
    def noted
      
    end
  end
  describe Elements::Cucumber do
    before(:each) do
      @runtime = Cucumber::Runtime.new
    
      @runtime.load_programming_language('rb')
      @dsl = Object.new
      @dsl.extend(::Cucumber::RbSupport::RbDsl)
    
      @dsl.Given(/^it gets noted$/) do
        Note.noted
      end
      
      @dsl.Given(/^it gets called$/) do
        Note.called
      end
      
      @dsl.Given(/^it freaks out$/) do
        raise "ah!"
      end
      
    
      @visitor = ::Cucumber::Ast::TreeWalker.new(@runtime)
      Config.stubs(:elements).returns([Elements::Cucumber])
    end
    
    it "should call the steps" do
      Note.expects(:called).once
      Note.expects(:noted).once
      markdown = Markdown.new("# title\n* Given it gets noted\n* Given it gets called")
      markdown.accept(@visitor)
      markdown.step_count.should == 2
      markdown.should_not be_failed
    end
    
    it "should fail on step failure" do
      markdown = Markdown.new("# title\n* Given it freaks out")
      markdown.accept(@visitor)
      markdown.step_count.should == 1
      markdown.should be_failed
    end
  end
end