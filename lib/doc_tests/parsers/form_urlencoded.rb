module DocTests
  module Parsers
    extend self
    
    def form_urlencoded_to_hash(content)
      content.split('&').inject({}) do |hash, param|
        key, value = param.split('=')
        hash[key]  = value
        hash
      end
    end
    
  end
end
