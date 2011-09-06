module DocTests
  module Config
    extend self

    def extensions=array
      @extensions = array
    end
    def extensions
      @extensions ||= ["markdown", "mdown", "md"]
    end
    
    def render_options
      @render_options ||= { :fenced_code_blocks => true }
    end
    def render_options=options
      @render_options = options
    end
    
    def register(element)
      elements << element
    end
    
    def elements
      @elements ||= []
    end
    
    def response_compare=val
      @response_compare = val      
    end
    def response_compare
      @response_compare ||= :include
    end
    
    def excluded_keys
      @excluded_keys ||= %w(id created_at updated_at)
    end

    def excluded_keys=(keys)
      @excluded_keys = keys.map{|k| k.to_s }.uniq
    end

    def exclude_keys(*keys)
      self.excluded_keys = keys
    end
  end
end

