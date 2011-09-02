require "spec_helper"

module DocTests
  module Parsers
    extend self
    
    def test_to_integer(val)
      return 100 if val.to_i == 0
      val.to_i
    end
    
    def first_to_string(val)
      
    end
    
    def second_to_string(val)
      
    end
    
  end
  
  describe Parser do
    describe ".find" do
      it "should find the first defined method" do
        Parser.new("test", "integer").find.should == "test_to_integer"
        Parser.new(["test", "other"], "integer").find.should == "test_to_integer"
        Parser.new(["other", "test"], "integer").find.should == "test_to_integer"
        Parser.new("test", ["integer", "other"]).find.should == "test_to_integer"
        Parser.new(["other", "test"], ["other", "integer"]).find.should == "test_to_integer"
        
        lambda{ Parser.new(["other", "bad"], ["integer", "bad"]).find }.should raise_error
        lambda{ Parser.new("bad", "integer").find }.should raise_error
        lambda{ Parser.new(["other", "test"], "bad").find }.should raise_error
        lambda{ Parser.new("test", ["bad", "other"]).find }.should raise_error
      end
    end
    describe ".get" do
      it "should parse when defined" do
        p = Parser.new("test", "integer")
        p.get(4).should == 4
        p.get("fhdjh").should == 100
        p.get("5").should == 5
      end
      it "should use list" do
        Parser.new(["test", "other"], "integer").get(4).should == 4
        Parser.new(["other", "test"], "integer").get(4).should == 4
      end
    end
  end
end