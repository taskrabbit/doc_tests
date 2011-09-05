require 'cucumber/cli/configuration'

module DocTests
  module Cucumber
    class Configuration < ::Cucumber::Cli::Configuration

      def initialize(out_stream = STDOUT, error_stream = STDERR)
        super(out_stream, error_stream)
        @options = DocTests::Cucumber::Options.new(@out_stream, @error_stream, :default_profile => 'default')
      end

      def paths
        paths = super
        if @options[:paths].empty? or @options[:paths] == ['features']
          paths = [doc_dir]
        end
        paths
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
      
      def step_defs_to_load
        cuke_step_defs_to_load + doc_step_defs_to_load
      end
      
      def support_to_load
        puts cuke_support_to_load
        puts doc_support_to_load
        cuke_support_to_load + doc_support_to_load
      end
      
      private
      
      def get_all_files_to_load(requires, extensions)
        files = requires.map do |path|
          path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
          path = path.gsub(/\/$/, '') # Strip trailing slash.
          File.directory?(path) ? Dir["#{path}/**/*"] : path
        end.flatten.uniq
        remove_excluded_files_from(files)
        files.reject! {|f| !File.file?(f)}
        files.reject! {|f| extensions.include? File.extname(f) }
        files.reject! {|f| f =~ /^http/}
        files.sort
      end
      
      def doc_step_defs_to_load
        doc_all_files_to_load.reject {|f| f =~ %r{/support/} }
      end      
      
      def cuke_step_defs_to_load
        cuke_all_files_to_load.reject {|f| f =~ %r{/support/} }
      end
      
      def doc_env_files_to_load
        support_files = doc_all_files_to_load.select {|f| f =~ %r{/support/} }
        support_files.select {|f| f =~ %r{/support/env\..*} }
      end
      
      def doc_support_to_load
        support_files = doc_all_files_to_load.select {|f| f =~ %r{/support/} }
        env_files = support_files.select {|f| f =~ %r{/support/env\..*} }
        other_files = support_files - env_files
        @options[:dry_run] ? other_files : env_files + other_files
      end
      
      def cuke_support_to_load
        support_files = cuke_all_files_to_load.select {|f| f =~ %r{/support/} }
        env_files = support_files.select {|f| f =~ %r{/support/env\..*} }
        other_files = support_files - env_files
        env_files = [] if doc_env_files_to_load.size > 0
        @options[:dry_run] ? other_files : env_files + other_files
      end
      
      def doc_all_files_to_load
        requires = @options[:require].empty? ? require_dirs : @options[:require]
        exclude_ext = DocTests::Config.extensions.collect{ |ext| ".#{ext}" }
        files = get_all_files_to_load(requires, exclude_ext)
        files += get_all_files_to_load(Dir[doc_dir], exclude_ext)
        files.uniq.sort
      end
      
      def cuke_all_files_to_load
        return [] unless base_cucumber_include
        get_all_files_to_load(Dir[cuke_dir], [".feature"])
      end
      
      def standalone?
        @options[:env_vars]["STANDALONE"] and not @options[:env_vars]["STANDALONE"] == "false"
      end
      
      def doc_dir
        if @options[:env_vars]["DOCDIR"]
          @options[:env_vars]["DOCDIR"]
        else
          'markdown'
        end
      end
      
      def cuke_dir
        if @options[:env_vars]["CUKEDIR"]
          @options[:env_vars]["CUKEDIR"]
        else
          'features'
        end
      end
      
      def base_cucumber_include
        standalone? ? nil : cuke_dir
      end
      
      def require_dirs
        req = feature_dirs
        req += Dir['vendor/{gems,plugins}/*/cucumber'] unless standalone?
        req
      end
    end
  end
end

