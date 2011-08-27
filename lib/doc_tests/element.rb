module DocTests
  class Element < Redcarpet::Render::Base
    def match?(text)
      false
    end
  end
end