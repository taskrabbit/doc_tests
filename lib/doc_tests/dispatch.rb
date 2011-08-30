require "cucumber/ast/step_invocation"
require "cucumber/ast/step"
require "cucumber/step_match"

module DocTests
  class Dispatch < Redcarpet::Render::Base
    class Match < ::Cucumber::StepMatch
      def initialize(step)
        @step = step
        # super(step_definition, name_to_match, name_to_report, step_arguments)
        super(@step, "name to match", "" + @step.name, [])
      end
      
      def invoke(multiline_arg)
        @step.invoke
      end
    end
    class Invocation < ::Cucumber::Ast::StepInvocation
      def find_step_match!(step_mother, configuration)
        return if @step_match
        @step_match = Match.new(@step)
        step_mother.step_visited(self)
      end
    end
    
    class Step < ::Cucumber::Ast::Step
      def initialize(method_name, array, current_elements, counter)
        @current_elements = current_elements
        @method_name = method_name
        @array = array
        super(counter, "", calc_name)
      end
      
      def calc_name
        case @method_name
        when "preprocess"
          "Preprocess Document"
        when "postprocess"
          "Postprocess Document"
        when "entity"
          @array.first.to_s
        when "normal_text"
          @array.first.to_s
        when "doc_header"
         "Document Header"
        when "doc_footer"
         "Document Footer"
        else
          @method_name
        end
      end
      
      def step_invocation
        inv = Invocation.new(self, @name, @multiline_arg, [])
        ::Cucumber::Ast::StepCollection.new([inv])
        inv
      end
      
      def invoke
        @current_elements.each do |instance|
          if instance.respond_to?(@method_name)
            instance.send(@method_name, *@array)
          end
        end
      end
    end
    
    
    VALID_TAGS = [:h1, :h2, :h3, :h4, :h5, :h6, :list, :list_item, :doc]

    def initialize(collection, visitor)
      reset
      @collection = collection
      @visitor = visitor
      super()
    end
    
    def reset
      @element_hash = nil
      @current_elements = nil
      @counter = 1
    end
    
    def elements(tag)
      @element_hash ||= {}
      @element_hash[tag] ||= []
    end
    
    def current_elements
      @current_elements ||= []
    end
    
    def add_element(clazz)
      instance = clazz.new
      instance.before(@visitor) if instance.respond_to?(:before)
      current_elements.push instance
    end
    
    def remove_elements(instances)
      instances.each do |instance|
        current_elements.delete(instance)
        instance.after if instance.respond_to?(:after)
      end
    end

    def current_send(method_name, array)
      @counter += 1
      step = Step.new(method_name, array, current_elements, @counter)
      step.step_collection = @collection
      step.feature_element = @collection.markdown
      step_invocation = step.step_invocation
      step_invocation.step_collection = @collection
      @visitor.visit_step(step_invocation)
    end
    
    def push_tag!(tag, array)
      elements(tag.to_sym).each do |clazz|
        add_element(clazz) if clazz.matches?(*array)
      end
    end
    
    def push_tags!(tags, array)
      tags.each do |tag|
        push_tag!(tag, array)
      end
    end
    
    def pop_tag!(tag)
      pop_tags!([tag])
    end
    
    def pop_tags!(tags)
      tags = tags.collect(&:to_sym)
      to_remove = []
      current_elements.each do |instance|
        if tags.include? instance.class.tag.to_sym
          to_remove << instance
        end
      end
      remove_elements(to_remove)
    end

    def header(text, level)
      pop_tags!(level.upto(6).collect{ |i| "h#{i}" }) # equal or smaller levels 
      push_tag!("h#{level}", [text, level])
      current_send('header', [text, level])
      "" # don't return anything but a string
    end
  

    def preprocess(full_document)
      reset
      
      Config.elements.each do |e|
        tag = e.tag.to_sym
        raise "Element tag #{tag} is not valid. Valid symbols: [#{VALID_TAGS.join(', ')}]" unless VALID_TAGS.include?(tag)
        elements(tag) << e
      end
      
      push_tag!(:doc, [full_document])
      current_send('preprocess', [full_document])
      full_document
    end
  
    def postprocess(full_document)
      current_send('postprocess', [full_document])
      remove_elements(current_elements)
      full_document
    end
    
    # low level
    [
    	"entity",
    	"normal_text"
  	].each do |method_name|
  	  define_method(method_name) do |*args|
    	  current_send(method_name, args)
        args.first
      end
    end
  
    # from rc_render.c
    [
    	"block_code",
    	"block_quote",
    	"block_html",
    	# implemented above "header",
    	"hrule",
    	"list",
    	"list_item",
    	"paragraph",
    	"table",
    	"table_row",
    	"table_cell",

    	"autolink",
    	"codespan",
    	"double_emphasis",
    	"emphasis",
    	"image",
    	"linebreak",
    	"link",
    	"raw_html",
    	"triple_emphasis",
    	"strikethrough",
    	"superscript",

    	# low level above "entity",
    	# low level above "normal_text",

    	"doc_header",
    	"doc_footer"
    ].each do |method_name|
      define_method(method_name) do |*args|
        current_send(method_name, args)
        ""
      end
    end

  end
end

=begin
  # Block-level calls
  block_code(code, language)
  block_quote(quote)
  block_html(raw_html)
  header(text, header_level)
  hrule()
  list(contents, list_type)
  list_item(text, list_type)
  paragraph(text)
  table(header, body)
  table_row(content)
  table_cell(content, alignment)

  # Span-level calls
  # A return value of `nil` will not output any data
  # If the method for a document element is not implemented,
  # the contents of the span will be copied verbatim
  autolink(link, link_type)
  codespan(code)
  double_emphasis(text)
  emphasis(text)
  image(link, title, alt_text)
  linebreak()
  link(link, title, content)
  raw_html(raw_html)
  triple_emphasis(text)
  strikethrough(text)
  superscript(text)

  # Low level rendering
  entity(text)
  normal_text(text)

  # Header of the document
  # Rendered before any another elements
  doc_header()

  # Footer of the document
  # Rendered after all the other elements
  doc_footer()

  # Pre/post-process
  # Special callback: preprocess or postprocess the whole
  # document before or after the rendering process begins
  preprocess(full_document)
  postprocess(full_document)
=end
