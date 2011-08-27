module DocTests
  class Header < Redcarpet::Render::Base
    def match?(text)
      false
    end
  end
end