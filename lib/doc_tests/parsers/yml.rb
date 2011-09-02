module DocTests
  module Parsers
    extend self
    
    def yml_to_hash(yml)
      YAML.load(yml)
    end
    
    def yml_to_request_data(yml)
      yml_to_hash(yml)
    end
  end
end