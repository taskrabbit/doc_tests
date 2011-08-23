require 'spec_helper'

describe DocTests::Config do
  describe ".directory" do
    before(:each) do
      @back = DocTests::Config.directory
    end
    after(:each) do
      DocTests::Config.directory = @back
    end
    it "should be set in the spec_helper" do
      test = File.join(File.dirname(__FILE__), 'examples')
      DocTests::Config.directory.should == test
    end
    
    it "can be set to nil" do
      DocTests::Config.directory = nil
      DocTests::Config.directory.should be_nil
    end
    
    it "can be set to directory with nothing useful in it" do
      test = File.join(File.dirname(__FILE__), 'rails')
      DocTests::Config.directory = test
      DocTests::Config.directory.should == test
    end
    
    it "should not raise error if set to non-existent directory" do
      test = File.join(File.dirname(__FILE__), 'none')
      DocTests::Config.directory = test
      DocTests::Config.directory.should == test
    end
  end
  
  describe ".extensions" do
    before(:each) do
      DocTests::Config.extensions = nil
    end
    after(:each) do
      DocTests::Config.extensions = nil
    end
    it "can should default to markdown extensions" do
      DocTests::Config.extensions.should =~ ["markdown", "mdown", "md"]
    end
    it "can be overriden" do
      DocTests::Config.extensions = ["ok"]
      DocTests::Config.extensions.should =~ ["ok"]
    end
    it "can be appended to" do
      DocTests::Config.extensions << "ok"
      DocTests::Config.extensions.should =~ ["markdown", "mdown", "md", "ok"]
      DocTests::Config.extensions += ["else", "now"]
      DocTests::Config.extensions.should =~ ["markdown", "mdown", "md", "ok", "else", "now"]
    end
  end
  
  describe ".documents" do
    it "should load documents with correct extension" do
      files = DocTests::Config.documents.collect(&:file_name)
      files.should include File.join(DocTests::Config.directory, "one.mdown")
      files.should include File.join(DocTests::Config.directory, "two.markdown")
      files.should include File.join(DocTests::Config.directory, "sub", "three.md")
      files.should include File.join(DocTests::Config.directory, "sub", "deep", "four.mdown")
      files.should_not include File.join(DocTests::Config.directory, "other.txt")
    end
  end
end