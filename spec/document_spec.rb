require "spec_helper"

describe DocTests::Document do
  it "should check the elements for interest" do
    element = DocTests::Element.new
    DocTests::Config.stubs(:elements).returns([element])
    element.expects(:matches?).once
    doc = DocTests::Config.document("one.mdown")
    doc.parse!
  end
end