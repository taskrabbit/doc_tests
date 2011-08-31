module DocTests
  class Element
    def self.tag
      :none
    end
    
    attr_reader :parent;
    def initialize(parent)
      @parent = parent
    end
    
    def self.matches?(*args)
      # TODO: warning? true?
      false
    end
  end
end