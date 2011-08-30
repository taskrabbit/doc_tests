require 'cucumber/cli/configuration'

module DocTests
  module Cucumber
    class Configuration < ::Cucumber::Cli::Configuration

      def paths
        paths = super
        if @options[:paths].empty? or @options[:paths] == ['features']
          paths = ['markdown']
        end
        paths
      end
      
      def all_files_to_load
        requires = @options[:require].empty? ? require_dirs : @options[:require]
        files = requires.map do |path|
          path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
          path = path.gsub(/\/$/, '') # Strip trailing slash.
          File.directory?(path) ? Dir["#{path}/**/*"] : path
        end.flatten.uniq
        remove_excluded_files_from(files)
        files.reject! {|f| !File.file?(f)}
        files.reject! {|f| DocTests::Config.extensions.collect{ |ext| ".#{ext}"}.include? File.extname(f) }
        files.reject! {|f| f =~ /^http/}
        files.sort
      end
      
      def feature_files
        potential_feature_files = paths.map do |path|
          path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
          path = path.chomp('/')
          if File.directory?(path)
            Dir["#{path}/**/*.{#{DocTests::Config.extensions.join(',')}}"].sort
          elsif path[0..0] == '@' and # @listfile.txt
              File.file?(path[1..-1]) # listfile.txt is a file
            IO.read(path[1..-1]).split
          else
            path
          end
        end.flatten.uniq
        remove_excluded_files_from(potential_feature_files)
        potential_feature_files
      end  
      
      private
      
      def require_dirs
        feature_dirs + Dir['vendor/{gems,plugins}/*/cucumber'] + Dir['features']
      end
    end
  end
end

