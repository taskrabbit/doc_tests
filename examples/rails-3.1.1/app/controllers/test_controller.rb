class TestController < ActionController::Base
  def test
    @rails = true
    render :text => "<html><body>Hello World</body></html>"
  end
  
  def info
    # talk about what was submitted
    headers = {}
    ['Accept', 'Authorization'].each do |name|
      headers[name] = request.headers[name]
    end
    headers['Content-Type'] = request.content_type.to_s
    
    symbol = request.format.to_s.include?("xml") ? :xml : :json
    
    
    render symbol => {
      :format => request.format,
      :method => request.method.downcase,
      :headers => headers,
      :params => params
    }
  end
end