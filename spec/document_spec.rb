require "spec_helper"

describe DocTests::Document do
  it "should check the headers for interest" do
    header = DocTests::Header.new
    DocTests::Config.stubs(:headers).returns([header])
    header.expects(:matches?).once
    doc = DocTests::Config.document("one.mdown")
    doc.parse!
  end
end