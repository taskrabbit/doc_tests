require 'rack/test'

module DocTests
  module Elements
    class Request < DocTests::Element
      attr_reader :command
      
      class Command
        #include Rack::Test::Methods
        
        attr_reader :cmd, :url
        def initialize(cmd, url)
          @cmd = cmd
          @url = url
        end
        
        def rack
          ::Capybara.current_session.driver
        end
        
        def title
          "#{cmd.to_s.upcase} #{url}"
        end
        
        def execute!
          case cmd
          when :get
            rack.get url
          when :delete
            
          when :post
            
          when :put
            
          else
            raise "Unknown method"            
          
          end
        end
      end
      
      def self.tag
        :h3
      end
      
      def self.matches?(text, level)
        return false unless level == 3
        !(text =~ /request/i).nil? || !parse_command(text).nil?
      end
      
      def self.parse_command(cmd)
        return nil if cmd.nil? or cmd.strip.length == 0
        pieces = cmd.split
        return nil unless pieces.size == 2
        
        method = pieces[0]
        url = pieces[1]
        return Command.new(:get, url) if method == "GET"
        return Command.new(:post, url) if method == "POST"
        return Command.new(:delete, url) if method == "DELETE"
        return Command.new(:put, url) if method == "PUT"
        
        nil
      end
      
      def execute!
        if @command
          parent.visit_block(@command.title) do
            @command.execute!
          end
        end
        @command = nil
      end
      def header(text, level)
        @command = self.class.parse_command(text)
        execute!
      end
      
      def after
        execute!
      end
      
    end
  end
end