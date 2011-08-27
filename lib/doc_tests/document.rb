module DocTests
  class Document
    def self.markdown
      @markdown ||= Redcarpet::Markdown.new(Render, {})
    end
    
    attr_accessor :file_name
    def initialize(file_name)
      self.file_name = file_name
    end
    
    def content
      File.read(file_name)
    end
    
    def parse!
      self.class.markdown.render(content)
    end
  end
end