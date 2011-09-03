require "spec_helper"

module DocTests
  describe Elements::Response do
    describe ".tag" do
      it "should use h3" do
        Elements::Response.tag.should == :h3
      end
    end
    
    describe ".matches?" do
      it "should return true if text correct" do
        Elements::Response.matches?("Response", 3).should be_true
        Elements::Response.matches?("Response", 2).should be_false
        Elements::Response.matches?("Something", 3).should be_false
        
        Elements::Response.matches?("Whatever response made", 3).should be_true
      end
      it "should return same as parse_code" do
        Elements::Response.stubs(:parse_code).returns([200, "OK"])
        Elements::Response.matches?("cmd", 2).should be_false
        Elements::Response.matches?("cmd", 3).should be_true

        Elements::Response.stubs(:parse_code).returns(nil)
        Elements::Response.matches?("cmd", 3).should be_false
      end
    end
    
    describe ".parse_code" do
      it "should return for valid codes" do
        Elements::Response.parse_code("200 OK").should == [200, "OK"]
        Elements::Response.parse_code("200 ok").should == [200, "OK"]
        Elements::Response.parse_code("200 no").should == nil
        
        Elements::Response.parse_code("201 Created").should == [201, "Created"]
        Elements::Response.parse_code("Created").should == nil
        Elements::Response.parse_code("201 Created Something").should == nil
        Elements::Response.parse_code("201 Created2").should == nil
      end
    end
  end
end