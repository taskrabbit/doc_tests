module DocTests
  class Element
    def self.tag
      :none
    end
    
    def self.matches?(*args)
      false
    end
  end
end