module DocTests
  class Document
    attr_accessor :file_name
    def initialize(file_name)
      self.file_name = file_name
    end
  end
end