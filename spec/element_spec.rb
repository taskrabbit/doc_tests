require "spec_helper"

module DocTests
  class TestElement < Element
    def self.tag
      :h2
    end
  
    def initialize(parent)
      init
    end
  
    def init
    
    end
  end

  describe Element do
    before(:each) do
      @runtime = Cucumber::Runtime.new
      @visitor = ::Cucumber::Ast::TreeWalker.new(@runtime)
      @markdown = Markdown.new("stubbed")
      @markdown.init
    end
  
    it "should be called when parsing level 2" do
      @markdown.stubs(:content).returns("## Two\n### Three")
    
      Config.stubs(:elements).returns([TestElement])
      TestElement.expects(:matches?).with("Two", 2).returns(false)
      TestElement.any_instance.expects(:init).never
      TestElement.any_instance.expects(:header).never
      @markdown.accept(@visitor)
    end
  
    it "should be called when parsing level 3 if matches" do
      @markdown.stubs(:content).returns("## Two\n### Three")

      Config.stubs(:elements).returns([TestElement])
      TestElement.expects(:matches?).with("Two", 2).returns(true)
      TestElement.any_instance.expects(:init).once
      TestElement.any_instance.expects(:header).twice
      @markdown.accept(@visitor)
    end
  
    it "should be called for lists if matches" do
      @markdown.stubs(:content).returns("## Two\n* Three\n\n* Four\n\nsomething\n\n* Five\n* Six\n\n\n---------------------------------------")
    
      Config.stubs(:elements).returns([TestElement])
      TestElement.expects(:matches?).with("Two", 2).returns(true)
      TestElement.any_instance.expects(:init).once
      #element.expects(:list).once
      #element.expects(:list_item).twice
      @markdown.accept(@visitor)
    end
  
    describe "before and after hooks" do
      it "should be called if defined" do
        @markdown.stubs(:content).returns("## Two\n### Three")

        Config.stubs(:elements).returns([TestElement])
        TestElement.expects(:matches?).with("Two", 2).returns(true)
        TestElement.any_instance.expects(:before).once
        TestElement.any_instance.expects(:after).once
        @markdown.accept(@visitor)
      end
    end
  end
end