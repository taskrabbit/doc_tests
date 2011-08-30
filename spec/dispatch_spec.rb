require "spec_helper"

class ElementOne < DocTests::Element
  def self.tag
    :h1
  end
end

class ElementTwo < DocTests::Element
  def self.tag
    :h2
  end
end

class ElementThree < DocTests::Element
  def self.tag
    :h3
  end
end

class ElementThree2 < DocTests::Element
  def self.tag
    :h3
  end
end

class ElementNone < DocTests::Element
  def self.tag
    :else
  end
end

class ElementDoc < DocTests::Element
  def self.tag
    :doc
  end
end 

describe DocTests::Dispatch do
  before(:each) do
    runtime = DocTests::Cucumber::Runtime.new
    visitor = ::Cucumber::Ast::TreeWalker.new(runtime)
    collection = ::DocTests::Markdown::Collection.new(DocTests::Markdown.new("rough test"))
    @dispatch = DocTests::Dispatch.new(collection, visitor)
  end
  
  describe "#preprocess" do
    it "should load the elements" do
      DocTests::Config.stubs(:elements).returns([ElementOne, ElementTwo, ElementThree, ElementThree2])
      @dispatch.elements(:h2).should == []
      @dispatch.preprocess(nil)
      @dispatch.elements(:h1).should == [ElementOne]
      @dispatch.elements(:h2).should == [ElementTwo]
      @dispatch.elements(:h3).should == [ElementThree, ElementThree2]
      @dispatch.elements(:h4).should == []
    end
    it "should raise an exception if not known" do
      DocTests::Config.stubs(:elements).returns([ElementOne, ElementNone])
      lambda { @dispatch.preprocess(nil) }.should raise_error
    end
    it "should call doc level elements" do
      DocTests::Config.stubs(:elements).returns([ElementOne, ElementDoc])
      ElementOne.stubs(:matches?).returns(true)
      ElementDoc.stubs(:matches?).returns(true)

      @dispatch.current_elements.size.should == 0
      @dispatch.preprocess(nil)
      @dispatch.current_elements.size.should == 1
      @dispatch.current_elements.first.class.should == ElementDoc
    end
  end
  
  describe "#header" do
    it "should trigger addition and removal to current_elements" do
      DocTests::Config.stubs(:elements).returns([ElementOne, ElementTwo, ElementThree, ElementThree2])
      ElementOne.stubs(:matches?).returns(true)
      ElementTwo.stubs(:matches?).returns(true)
      ElementThree.stubs(:matches?).returns(true)
      ElementThree2.stubs(:matches?).returns(true)
      
      @dispatch.preprocess(nil)
      
      @dispatch.current_elements.should be_empty
      
      @dispatch.header("something", 2)
      @dispatch.current_elements.size.should == 1
      @dispatch.current_elements.first.class.should == ElementTwo
      
      @dispatch.header("something", 1)
      @dispatch.current_elements.size.should == 1
      @dispatch.current_elements.first.class.should == ElementOne
      
      @dispatch.header("something", 2)
      @dispatch.current_elements.size.should == 2
      @dispatch.current_elements.first.class.should == ElementOne
      @dispatch.current_elements.last.class.should == ElementTwo
      
      @dispatch.header("something", 3)
      @dispatch.current_elements.size.should == 4
      @dispatch.current_elements.last.class.should == ElementThree2
      
      @dispatch.header("something", 4)
      @dispatch.current_elements.size.should == 4
      @dispatch.current_elements.last.class.should == ElementThree2
      
      ElementThree2.stubs(:matches?).returns(false)
      @dispatch.header("something", 3)
      @dispatch.current_elements.size.should == 3
      @dispatch.current_elements.last.class.should == ElementThree
    end
  end
end