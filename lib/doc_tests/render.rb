class Render < Redcarpet::Render::Base
  def header(*args)
    text = args.first
    level = args.last
    case level
    when 1
      self.current = nil
    when 2
      self.current = find_header(text)
    else
      current_send('header',*args)
    end
    "" # don't return anything but a string
  end
  

  def preprocess(full_document)
    self.current = nil
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
  def current_send(method_name, *args)
    if current_has?(method_name)
      current.send(method_name, *args)
    else
      nil
    end
  end

  def find_header(text)
    found = nil
    DocTests::Config.headers.each do |h|
      if h.matches?(text)
        raise "DocTests::Render ound two headers for text: #{text}" if found
        found = h
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
      current_send(method_name, *args)
      ""
    end
  end

end
