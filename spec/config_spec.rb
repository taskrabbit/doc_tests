require 'spec_helper'

module DocTests
  describe Config do
    describe ".extensions" do
      before(:each) do
        Config.extensions = nil
      end
      after(:each) do
        Config.extensions = nil
      end
      it "can should default to markdown extensions" do
        Config.extensions.should =~ ["markdown", "mdown", "md"]
      end
      it "can be overriden" do
        Config.extensions = ["ok"]
        Config.extensions.should =~ ["ok"]
      end
      it "can be appended to" do
        Config.extensions << "ok"
        Config.extensions.should =~ ["markdown", "mdown", "md", "ok"]
        Config.extensions += ["else", "now"]
        Config.extensions.should =~ ["markdown", "mdown", "md", "ok", "else", "now"]
      end
    end
  end
end