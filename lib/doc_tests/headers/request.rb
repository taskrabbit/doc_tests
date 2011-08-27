module DocTests
  module Headers
    class Request < DocTests::Header
      def match?(text)
        false
      end
    end
  end
end