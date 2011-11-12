require "spec_helper"

module DocTests
  module Elements
    describe Differ do
      describe ".exclude_keys" do
        it "should remove the given keys" do
          DocTests::Config.excluded_keys.should =~ ["id", "created_at", "updated_at"]
          hash = {:name => "ok", :id => 4, :sub => {:two => 2, :deep => {:created_at => Time.now}}}
          remo = {:name => "ok", :sub => {:two => 2, :deep => {}}}
          Differ.exclude_keys(hash, Set.new(DocTests::Config.excluded_keys)).should == remo
        end
        it "works for hashes inside arrays" do
          arr = ["ok", {:id => 3, :name => "one"}]
          rem = ["ok", {:name => "one"}]
          Differ.exclude_keys(arr, Set.new(DocTests::Config.excluded_keys)).should == rem
        end
      end
      describe ".equal!" do
        it "should check equality" do
          haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
          needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "1" }
          lambda { Differ.equal!(needles, haystack) }.should_not raise_error
        end
        it "should raise error if more in haystack" do
          haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}, :extra => "7"}
          needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "1" }
          lambda { Differ.equal!(needles, haystack) }.should raise_error
        end
        it "should raise error if less in haystack" do
          haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
          needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "1", :extra => "7"}
          lambda { Differ.equal!(needles, haystack) }.should raise_error
        end
      end
      
      describe ".include_check" do
        
        context "when using skipping matcher" do
          it "should check equality" do
            haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
            needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "<<some value to skip>>" }
            Differ.include_check(needles, haystack).should be_empty
          end

          it "should raise error if less in haystack" do
            haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
            needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "1", :extra => "<<some value to skip>>"}
            Differ.include_check(needles, haystack).should_not be_empty
          end

          it "should not raise error if value matches the the skipping matcher" do
            haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}, :extra => "7"}
            needles = { :two => "2", :sub => {:deep => {:six => "<<some value to skip>>"}, :four => "4", :five => "5"}, :one => "1" }
            Differ.include_check(needles, haystack).should be_empty
          end
        end
        
        context "when using the between matcher" do
          it "should check equality" do
            haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
            needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "%{BETWEEN 0.5 AND 1.5}" }
            Differ.include_check(needles, haystack).should be_empty
          end

          it "should be valid when including the value" do
            haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
            needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "%{BETWEEN 1 AND 2}" }
            Differ.include_check(needles, haystack).should be_empty
          end

          it "should not be valid when not including the value" do
            haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
            needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "%{BETWEEN 3 AND 2}" }
            Differ.include_check(needles, haystack).should_not be_empty
          end

          it "should not raise error if value matches the the skipping matcher" do
            haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}, :extra => "7"}
            needles = { :two => "2", :sub => {:deep => {:six => "<<BETWEEN 5 AND 7>>"}, :four => "4", :five => "5"}, :one => "1" }
            Differ.include_check(needles, haystack).should be_empty
          end
        end
        
        # returns an error message
        it "should check equality" do
          haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
          needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "1" }
          Differ.include_check(needles, haystack).should be_empty
        end
        it "should not raise error if more in haystack" do
          haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}, :extra => "7"}
          needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "1" }
          Differ.include_check(needles, haystack).should be_empty
        end
        it "should raise error if less in haystack" do
          haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
          needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "1", :extra => "8"}
          Differ.include_check(needles, haystack).should_not be_empty
        end
        it "should work deeply yes" do
          haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6", :extra => "9"}}}
          needles = { :two => "2", :sub => {:deep => {:six => "6"}, :four => "4", :five => "5"}, :one => "1" }
          Differ.include_check(needles, haystack).should be_empty
        end
        it "should report deeply when not found" do
          haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
          needles = { :two => "2", :sub => {:deep => {:six => "6", :extra => "9"}, :four => "4", :five => "5"}, :one => "1" }
          errors = Differ.include_check(needles, haystack)
          errors.size.should == 1
          errors.first.should == {:key=>"sub/deep/extra", :messsage=>"not found!"}
        end
        it "should report deeply when not found" do
          haystack = { :one => "1", :two => "2", :sub => {:four => "4", :five => "5", :deep => {:six => "6"}}}
          needles = { :two => "2", :sub => {:deep => {:six => "7"}, :four => "4", :five => "5"}, :one => "1" }
          errors = Differ.include_check(needles, haystack)
          errors.size.should == 1
          errors.first.should == {:key=>"sub/deep/six", :expected=>"7", :got=>"6"}
        end
      end
    end
  end
end
