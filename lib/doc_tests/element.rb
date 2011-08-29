module DocTests
  class Element
    def self.tag
      :none
    end
    
    def self.matches?(*args)
      # TODO: warning? true?
      false
    end
  end
end