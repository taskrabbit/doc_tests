require 'cucumber/cli/options'
require 'cucumber/cli/profile_loader'

module DocTests
  module Cucumber
    
    class ProfileLoader < ::Cucumber::Cli::ProfileLoader
      def cucumber_file
        return @cucumber_file if @cucumber_file
        # use a doctests one if it's there
        @cucumber_file = Dir.glob('{,.config/,config/}doctests{.yml,.yaml}').first
        return @cucumber_file if @cucumber_file
        @cucumber_file = Dir.glob('{,.config/,config/}cucumber{.yml,.yaml}').first
      end
    end
    
    class Options < ::Cucumber::Cli::Options
      def profile_loader
        @profile_loader ||= ProfileLoader.new
      end
    end
    
  end
end