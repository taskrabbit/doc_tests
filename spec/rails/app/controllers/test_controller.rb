class TestController < ActionController::Base
  def test
    @rails = true
    render :text => "<html><body>Hello World</body></html>"
  end
  
  def info
    # talk about what was submitted
    headers = {}
    ['Accept', 'Authorization', 'Content-type'].each do |name|
      headers[name] = request.headers[name]
    end
    
    render :json => {
      :method => request.method,
      :headers => headers,
      :params => params
    }
  end
end