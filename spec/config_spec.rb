require 'spec_helper'

describe DocTests::Config do
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
end