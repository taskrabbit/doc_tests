module DocTests
  class Parser
    def module_check
      DocTests::Parsers
    end
    def build_method(source, dest)
      "#{source}_to_#{dest}"
    end
    def args_count
      1
    end
    
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
          meth = build_method(source, dest)
          unless tried.include? meth
            return [meth, [meth]] if module_check.respond_to?(meth)
            tried << meth
          end
        end
      end
  
      [nil, tried]
    end
    
    def get(*args)
      meth, tried = self.find
      has_default = args.size > args_count
      default = args.pop if has_default
      if meth.nil?
        return default if has_default
        raise "Could not parse to #{@to.first}. Tried: #{tried.join(', ')}"
      else
        module_check.send(meth, *args)
      end
    end
  end
end