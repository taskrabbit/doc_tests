require "spec_helper"

class TestElement < DocTests::Element
  def self.tag
    :h2
  end
  
  def initialize
    init
  end
  
  def init
    
  end
end

describe DocTests::Element do
  it "should be called when parsing level 2" do
    doc = DocTests::Document.new(nil)
    doc.stubs(:content).returns("## Two\n### Three")
    
    DocTests::Config.stubs(:elements).returns([TestElement])
    TestElement.expects(:matches?).with("Two", 2).returns(false)
    TestElement.any_instance.expects(:init).never
    TestElement.any_instance.expects(:header).never
    doc.parse!
  end
  
  it "should be called when parsing level 3 if matches" do
    doc = DocTests::Document.new(nil)
    doc.stubs(:content).returns("## Two\n### Three")

    DocTests::Config.stubs(:elements).returns([TestElement])
    TestElement.expects(:matches?).with("Two", 2).returns(true)
    TestElement.any_instance.expects(:init).once
    TestElement.any_instance.expects(:header).twice
    doc.parse!
  end
  
  it "should be called for lists if matches" do
    doc = DocTests::Document.new(nil)
    doc.stubs(:content).returns("## Two\n* Three\n\n* Four\n\nsomething\n\n* Five\n* Six\n\n\n---------------------------------------")
    
    DocTests::Config.stubs(:elements).returns([TestElement])
    TestElement.expects(:matches?).with("Two", 2).returns(true)
    TestElement.any_instance.expects(:init).once
    #element.expects(:list).once
    #element.expects(:list_item).twice
    doc.parse!
  end
end