module DocTests
  module Parsers
    extend self
    
    def yml_to_hash(yml)
      YAML.load(yml)
    end
  end
end