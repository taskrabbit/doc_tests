module DocTests
  class Dispatch < Redcarpet::Render::Base
    VALID_TAGS = [:h1, :h2, :h3, :list, :list_item]
    
    def reset
      @element_hash = nil
    end
    
    def elements(tag)
      @element_hash ||= {}
      @element_hash[tag] ||= []
    end
    
    def current_elements
      @current_elements ||= []
    end
    
    def add_element(clazz)
      current_elements.push clazz.new
    end
    
    def remove_elements(instances)
      instances.each do |instance|
        current_elements.delete(instance)
      end
    end
    
    def current_send(method_name, *args)
      current_elements.each do |instance|
        if instance.respond_to?(method_name)
          instance.send(method_name, *args)
        end
      end
    end
    
    
    def header(*args)
      text = args.first
      level = args.last
      
      # close out old ones
      to_remove = []
      current_elements.each do |instance|
        tag = instance.class.tag.to_s
        if tag[0,1] == "h"
          to_remove << instance if tag[1,1].to_i >= level
        end
      end
      remove_elements(to_remove)
      
      
      elements("h#{level}".to_sym).each do |clazz|
        add_element(clazz) if clazz.matches?(*args)
      end
      
      current_send('header',*args)
      "" # don't return anything but a string
    end
  

    def preprocess(full_document)
      reset
      
      Config.elements.each do |e|
        tag = e.tag
        raise "Element tag #{tag} is not valid. Valid symbols: [#{VALID_TAGS.join(', ')}]" unless VALID_TAGS.include?(tag)
        elements(tag) << e
      end  
      full_document
    end
  
    def postprocess(full_document)
      self.current = nil
      full_document
    end

    def current
      @header
    end
    def current=h
      @header = h
    end
    def current_has?(method_name)
      current and current.respond_to?(method_name)
    end
    
    def find_element(text)
      found = nil
      DocTests::Config.elements.each do |e|
        if e.matches?(text)
          raise "DocTests::Render ound two headers for text: #{text}" if found
          found = e
        end
      end
      found
    end
  
    # low level
    [
    	"entity",
    	"normal_text"
  	].each do |method_name|
  	  define_method(method_name) do |*args|
    	  if current_has?(method_name)
  	      current_send(method_name, *args)
        else
          args.first
        end
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
        #puts "#{method_name}: #{args.join(', ')}"
        current_send(method_name, *args)
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
