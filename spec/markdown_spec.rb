require "spec_helper"

class DocElement < DocTests::Element
  def self.tag
    :h2
  end
end

class RenderTest < Redcarpet::Render::Base
  def preprocess(full_document)
    full_document
  end
  def header(text, level)
    hit
    ""
  end
  def hit
    
  end
end

describe DocTests::Markdown do
  before(:each) do
    @runtime = DocTests::Cucumber::Runtime.new
    @visitor = ::Cucumber::Ast::TreeWalker.new(@runtime)
  end
  it "should check the elements for interest" do
    DocTests::Config.stubs(:elements).returns([DocElement])
    DocElement.expects(:matches?).once
    markdown = DocTests::Markdown.new("# One\n## Second\n### Third")
    markdown.accept(@visitor)
  end
  
  it "should generally work" do
    RenderTest.any_instance.expects(:hit).twice
    ::Redcarpet::Markdown.new(RenderTest.new).render("## Two\n### Three")
  end
  
  describe ".content_options" do
    it "should calculate title based on highest level text" do
      DocTests::Markdown.content_options("")[:title].should == ""
      DocTests::Markdown.content_options("# something\nelse")[:title].should == "something"
      DocTests::Markdown.content_options("# something\nelse\n# same")[:title].should == "something"
      puts "-------------"
      DocTests::Markdown.content_options("## something\nelse\n# higher\n")[:title].should == "higher"
      DocTests::Markdown.content_options("## something\nelse\n### lower")[:title].should == "something"
      DocTests::Markdown.content_options("something here\n\nelse")[:title].should == "something here"
      DocTests::Markdown.content_options("something here\nelse")[:title].should == "something here"
    end
    
  end
end