require "spec_helper"

describe DocTests::Elements::Cucumber do
  before(:each) do
    DocTests::Config.stubs(:elements).returns([DocTests::Elements::Cucumber])
  end
  
  describe "Cucumber hooks" do
    it "should be called before and after document parsing" do
      DocTests::Elements::Cucumber.any_instance.expects(:before_feature)
      DocTests::Elements::Cucumber.any_instance.expects(:before_scenario)
      DocTests::Elements::Cucumber.any_instance.expects(:after_feature)
      DocTests::Elements::Cucumber.any_instance.expects(:after_scenario)
    
      doc = DocTests::Config.document("cuke.mdown")
      doc.parse!
    end
  end
end