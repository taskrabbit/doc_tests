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
    
    render :json => {
      :format => request.format,
      :method => request.method,
      :headers => headers,
      :params => params
    }
  end
end