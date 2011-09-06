module DocTests
  class Parser
    attr_reader :from, :to
    def initialize(from, to, options = {})
      @from = from.is_a?(Array) ? from.collect(&:to_s) : [from.to_s] 
      @to = to.is_a?(Array) ? to.collect(&:to_s) : [to.to_s]
      @options = options
    end
    
    def name
      "Parsing #{@from.first} to #{@to.first}"
    end
    
    def visit(*args)
      out = nil
      parent = args.shift
      parent.visit_block(name) do
        out = get(*args)
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
          unless tried.include? meth
            return [meth, [meth]] if DocTests::Parsers.respond_to?(meth)
            tried << meth
          end
        end
      end
  
      [nil, tried]
    end
    
    def get(*args)
      meth, tried = self.find
      if meth.nil?
        return args.second if args.size > 1
        raise "Could not parse to #{@to.first}. Tried: #{tried.join(', ')}"
      else
        DocTests::Parsers.send(meth, args.first)
      end
    end
  end
end