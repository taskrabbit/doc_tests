module DocTests
  module Config
    extend self
    attr_accessor :directory  # must be set to be useful

    def extensions=array
      @extensions = array
    end
    def extensions
      @extensions ||= ["markdown", "mdown", "md"]
    end
    
    def render_options
      @render_options || { :fenced_code_blocks => true }
    end
    def render_options=options
      @render_options = options
    end
    
    def documents
      raise "DocTests::directory not set!" unless directory
      raise "DocTests::directory (#{directory}) does not exist!" unless File.exist?(directory)
      raise "DocTests::directory (#{directory}) is not a directory!" unless File.directory?(directory)

      files = File.join(directory, "**", "*.{#{extensions.join(',')}}")
      Dir[files].collect{ |file| Document.new(file) }
    end
    
    def register(element)
      elements << element
    end
    
    def elements
      @elements ||= []
    end
    
    def document(relative_path)
      file = File.join(directory, relative_path)
      raise "DocTests::file (#{file}) does not exist!" unless File.exist?(file)
      Document.new(file)
    end
  end
end

