module DocTests
  module Equivalencies

  end
  
  class Equivalency
    class EqParser < Parser
      def module_check
        DocTests::Equivalencies
      end
      def build_method(source, dest)
        "#{source}_#{dest}?"
      end
      def args_count
        2
      end
    end
    
    def self.key_values?(key, value1, value2)
      pieces = key.split("/")
      keys = []
      until pieces.empty?
        keys << pieces.join("/")
        pieces.shift
      end
      
      p = EqParser.new("Key Values", keys)
      p.get(value1, value2, false)
    end
  end
end