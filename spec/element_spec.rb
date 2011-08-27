require "spec_helper"

describe DocTests::Element do
  it "should be called when parsing level 2" do
    doc = DocTests::Document.new(nil)
    doc.stubs(:content).returns("## Two\n### Three")
    
    element = DocTests::Element.new
    DocTests::Config.stubs(:elements).returns([element])
    element.expects(:matches?).with("Two").returns(false)
    element.expects(:header).never
    doc.parse!
  end
  
  it "should be called when parsing level 3 if matches" do
    doc = DocTests::Document.new(nil)
    doc.stubs(:content).returns("## Two\n### Three")
    
    element = DocTests::Element.new
    DocTests::Config.stubs(:elements).returns([element])
    element.expects(:matches?).with("Two").returns(true)
    element.expects(:header).once
    doc.parse!
  end
  
  it "should be called for lists if matches" do
    doc = DocTests::Document.new(nil)
    doc.stubs(:content).returns("## Two\n* Three\n\n* Four\n\nsomething\n\n* Five\n* Six\n\n\n---------------------------------------")

    element = DocTests::Element.new
    DocTests::Config.stubs(:elements).returns([element])
    element.expects(:matches?).with("Two").returns(true)
    #element.expects(:list).once
    #element.expects(:list_item).twice
    doc.parse!
  end
end