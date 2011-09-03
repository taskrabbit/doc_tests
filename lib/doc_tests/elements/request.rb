module DocTests
  module Elements
    class Request < DocTests::Element
      def self.rack
        ::Capybara.current_session.driver
      end
      
      attr_reader :command
      
      class Command
        attr_reader :cmd, :url
        attr_accessor :data
        def initialize(cmd, url)
          @cmd = cmd
          @url = url
        end
        
        def title
          "#{cmd.to_s.upcase} #{url}"
        end
        
        def rack
          Request.rack
        end
        
        def execute!
          case cmd
          when :get
            rack.get url
          when :delete
            rack.delete url
          when :post
            rack.post url, data
          when :put
            rack.put url, data
          else
            raise "Unknown request method"
          end
        end
        
        def block?
          cmd == :put or cmd == :post
        end
        
        def header(key, value)
          rack.header key, value
        end
      end
      
      def self.tag
        :h3
      end
      
      def self.matches?(text, level)
        return false unless level == 3
        !parse_command(text).nil?
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
          parent.visit_block("Requesting -> #{@command.title}") do
            @command.execute!
          end
        end
        @in_list = nil
        @command = nil
      end
      
      def header(text, level)
        return unless level == 3
        execute!
        parent.visit_block("Starting -> #{text}") do
          @command = self.class.parse_command(text)
        end
      end
      
      def block_code(code, language)
        return unless @command
        language ||= "YML"
        p = Parser.new(language, ["Request Data", "Hash"])
        @command.data = p.visit(parent, code)
        execute!
      end
      
      def before_list_item?(text, type)
        return false unless @command
        return true if @in_list
        return true if text.split(":").size == 2

        # run it before some other list item like cucumber
        execute!
        false
      end
      
      def list_item(text, type)
        @in_list = true
        parent.visit_block("Request Header -> #{text.strip}") do
          pieces = text.split(":")
          if pieces.size == 2
            @command.header(pieces[0].strip, pieces[1].strip)
          elsif @in_list
            raise "#{text} is an invalid header. Example... Authorization: token"
          end
        end
      end
      
      def list(content, type)
        execute! if @command and not @command.block?
        @in_list = false
      end
      
      def generic(method_name, args)
        # something we don't care about
        execute!
      end
      
      def after
        execute!
      end
      
    end
  end
end