require 'cucumber/runtime'

module DocTests
  module Cucumber
    class Runtime < ::Cucumber::Runtime
      
      private
      
      def features
        DocTests::Features.new(@configuration.feature_files)
      end
    end
  end
end
