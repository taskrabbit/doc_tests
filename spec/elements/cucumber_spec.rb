require "spec_helper"

module DocTests
  class Note
    def self.called
      
    end
    def self.noted
      
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
    
    describe "step matching" do
      it "should skip them all if the first one in a list is not right" do
        markdown = Markdown.new("# title\n* Something it gets called\n* Given it gets noted")
        markdown.accept(@visitor)
        markdown.step_count.should == 0
        markdown.should_not be_failed
      end
      
      it "should skip them all if the first one in a list is not right" do
        markdown = Markdown.new("# title\n* When it gets called\n* Given it gets noted\n\n## Next title\n\n*Something it gets noted\n* Given it freaks out\n\n### Header\n\n* When it gets noted")
        markdown.accept(@visitor)
        markdown.step_count.should == 3
        markdown.should_not be_failed
      end
    end
    
    describe ".step?" do
      it "should return true if it looks like a step" do
        Elements::Cucumber.step?("Given something").should == true
        Elements::Cucumber.step?("And something").should == true
        Elements::Cucumber.step?("Then something").should == true
        Elements::Cucumber.step?("When something").should == true
        
        Elements::Cucumber.step?("   Given something").should == true
        Elements::Cucumber.step?("And something   ").should == true
        Elements::Cucumber.step?("    Then someth  ing").should == true
        Elements::Cucumber.step?("   When something   ").should == true
        
        Elements::Cucumber.step?("given 9 somethings").should == true
        Elements::Cucumber.step?("and \"something\"").should == true
        Elements::Cucumber.step?("then something").should == true
        Elements::Cucumber.step?("when something").should == true
             
        Elements::Cucumber.step?("xiven something").should == false
        Elements::Cucumber.step?("Given").should == false
        Elements::Cucumber.step?("When    ").should == false
        Elements::Cucumber.step?("And").should == false
        Elements::Cucumber.step?("Then").should == false
        
        Elements::Cucumber.step?("I was Given something").should == false
      end
    end
  end
end