require "spec_helper"

module DocTests
  describe Elements::Request do
    describe ".tag" do
      it "should use h3" do
        Elements::Request.tag.should == :h3
      end
    end
    
    describe ".matches?" do
      it "should return false if unrelated" do
        Elements::Request.matches?("", 3).should == false
        Elements::Request.matches?("random rething", 3).should == false
      end
      it "should check for request" do
        Elements::Request.matches?("Request", 3).should == true
        Elements::Request.matches?("Request", 2).should == false
        Elements::Request.matches?("Request", 4).should == false
        
        Elements::Request.matches?("My Request", 3).should == true
        Elements::Request.matches?("Make the request to the server", 3).should == true
      end
    
      it "should return same as parse_command" do
        Elements::Request.stubs(:parse_command).returns(Object.new)
        Elements::Request.matches?("cmd", 2).should be_false
        Elements::Request.matches?("cmd", 3).should be_true

        Elements::Request.stubs(:parse_command).returns(nil)
        Elements::Request.matches?("cmd", 3).should be_false
      end
    end

    
    describe ".parse_command" do
      def cmp_cmd(result, method, url=nil)
        if method.nil?
          result.should be_nil
        else
          result.cmd.should == method
          result.url.should == url
        end
      end
      it "should return nil if not valid" do
        cmp_cmd(Elements::Request.parse_command("GET"), nil)
        cmp_cmd(Elements::Request.parse_command("GET something.html"), :get, "something.html")
        cmp_cmd(Elements::Request.parse_command("  GET   something.html  "), :get, "something.html")
        cmp_cmd(Elements::Request.parse_command("GET something here.html"), nil)
        cmp_cmd(Elements::Request.parse_command("RANDOM something.html"), nil)

        cmp_cmd(Elements::Request.parse_command("POST /else.html"), :post, "/else.html")
        cmp_cmd(Elements::Request.parse_command("PUT /users/34"), :put, "/users/34")
        cmp_cmd(Elements::Request.parse_command("DELETE users/35"), :delete, "users/35")
      end
    end
  end
end