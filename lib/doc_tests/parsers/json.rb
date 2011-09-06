require 'json'

module DocTests
  module Parsers
    extend self
    
    def json_to_hash(json)
      JSON.parse(json).to_hash
    end
        
    def json_to_request_data(json)
      json
    end
  end
end