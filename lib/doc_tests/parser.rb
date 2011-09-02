module DocTests
  class Parser
    attr_reader :from, :to
    def initialize(from, to)
      @from = from.is_a?(Array) ? from.collect(&:to_s) : [from.to_s] 
      @to = to.is_a?(Array) ? to.collect(&:to_s) : [to.to_s]
    end
    
    def name
      "Parsing #{@from.first} to #{@to.first}"
    end
    
    def visit(parent, value)
      out = nil
      parent.visit_block(name) do
        out = get(value)
      end
      out
    end
    
    def self.fixup(value)
      value.downcase.gsub(/[^a-zA-Z0-9]/, '_')
    end
    
    def find
      tried = []
      @from.each do |f|
        @to.each do |t|
          source = self.class.fixup(f)
          dest = self.class.fixup(t)
          meth = "#{source}_to_#{dest}"
          return meth if DocTests::Parsers.respond_to?(meth)

          tried << meth
        end
      end
        
      raise "Could not parse to #{@to.first}. Tried: #{tried.join(', ')}"
    end
    
    def get(value)
       DocTests::Parsers.send(find, value)
    end
  end
end