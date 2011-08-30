require 'cucumber/cli/main'
require 'doc_tests'

module DocTests
  module Cucumber
    class Main < ::Cucumber::Cli::Main
      class << self
        def go(args)
          new(args).go!
        end
      end
      
      def go!
        runtime = DocTests::Cucumber::Runtime.new(configuration)
        execute!(runtime)
      end
      
      def configuration
        return @configuration if @configuration

        @configuration = DocTests::Cucumber::Configuration.new(@out_stream, @error_stream)
        @configuration.parse!(@args)
        ::Cucumber.logger = @configuration.log
        @configuration
      end
    end
  end
end
