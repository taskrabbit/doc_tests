module DocTests
  module Parsers
    class Tester
      def test(*args)
        raise "test method not implemented for #{self.class} with #{args.size} arguments."
      end
    end
  end
end