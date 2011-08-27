require "spec_helper"

describe DocTests::Header do
  it "should be called when parsing level 2" do
    doc = DocTests::Document.new(nil)
    doc.stubs(:content).returns("## Two\n### Three")
    
    header = DocTests::Header.new
    DocTests::Config.stubs(:headers).returns([header])
    header.expects(:matches?).with("Two").returns(false)
    header.expects(:header).never
    doc.parse!
  end
  
  it "should be called when parsing level 3 if matches" do
    doc = DocTests::Document.new(nil)
    doc.stubs(:content).returns("## Two\n### Three")
    
    header = DocTests::Header.new
    DocTests::Config.stubs(:headers).returns([header])
    header.expects(:matches?).with("Two").returns(true)
    header.expects(:header).once
    doc.parse!
  end
  
  it "should be called for lists if matches" do
    doc = DocTests::Document.new(nil)
    doc.stubs(:content).returns("## Two\n* Three")

    header = DocTests::Header.new
    DocTests::Config.stubs(:headers).returns([header])
    header.expects(:matches?).with("Two").returns(true)
    header.expects(:list).once
    header.expects(:list_item).once
    doc.parse!
  end
end