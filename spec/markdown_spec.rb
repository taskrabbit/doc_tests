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
    markdown = DocTests::Config.document("one.mdown").markdowns.first
    markdown.accept(@visitor)
  end
  
  it "should generally work" do
    RenderTest.any_instance.expects(:hit).twice
    ::Redcarpet::Markdown.new(RenderTest.new).render("## Two\n### Three")
  end
end