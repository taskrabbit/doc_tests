require "spec_helper"

module DocTests
  describe Document do
    describe ".markdowns" do
      it "should parse one by horizontal rules" do
        Document.any_instance.stubs(:content).returns("* list item\n**** something else")
        Document.new(nil).markdowns.size.should == 1
      end
      it "should parse one by horizontal rules at end" do
        Document.any_instance.stubs(:content).returns("* list item\nx********")
        Document.new(nil).markdowns.size.should == 1
      end
      it "should parse one by horizontal rules hwne not enough" do
        Document.any_instance.stubs(:content).returns("* list item\n**\nparagraph")
        Document.new(nil).markdowns.size.should == 1
      end
      it "should parse two by horizontal rules" do
        Document.any_instance.stubs(:content).returns("* list item\n***\nparagraph")
        Document.new(nil).markdowns.size.should == 2
      end
      it "should parse two by horizontal rules with spaces" do
        Document.any_instance.stubs(:content).returns("* list item\n* * *\nparagraph")
        Document.new(nil).markdowns.size.should == 2
      end
      it "should parse two by horizontal rules with dashes" do
        Document.any_instance.stubs(:content).returns("* list item\n----------\nparagraph")
        Document.new(nil).markdowns.size.should == 2
      end
      it "should parse two by horizontal rules with extra whitespace" do
        Document.any_instance.stubs(:content).returns("* list item\n*****     \nparagraph")
        Document.new(nil).markdowns.size.should == 2
      end
      
      it "should parse two by horizontal rules with whitespace at beginning of line" do
        Document.any_instance.stubs(:content).returns("* list item\n   *****   \nparagraph")
        Document.new(nil).markdowns.size.should == 2
      end
      
      it "should parse two by horizontal rules when rule at beginning or end end" do
        Document.any_instance.stubs(:content).returns("-------\n* list item\n*****     \nparagraph\n*****")
        Document.new(nil).markdowns.size.should == 2
      end
      
      it "should parse two by horizontal rules when back to back" do
        Document.any_instance.stubs(:content).returns("* list item\n*****\n---\nparagraph\n*****")
        Document.new(nil).markdowns.size.should == 2
      end
      it "should parse two by horizontal rules when back to back with white space" do
        Document.any_instance.stubs(:content).returns("* list item\n*****\n     \n---\nparagraph\n*****")
        Document.new(nil).markdowns.size.should == 2
      end
    end
  end
end
