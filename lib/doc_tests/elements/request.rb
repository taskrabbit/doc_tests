module DocTests
  module Elements
    class Request < DocTests::Element
      def match?(text)
        false
      end
    end
  end
end