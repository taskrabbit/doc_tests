require "spec_helper"

class DocElement < DocTests::Element
  def self.tag
    :h2
  end

end

describe DocTests::Document do
  it "should check the elements for interest" do
    DocTests::Config.stubs(:elements).returns([DocElement])
    DocElement.expects(:matches?).once
    doc = DocTests::Config.document("one.mdown")
    doc.parse!
  end
end