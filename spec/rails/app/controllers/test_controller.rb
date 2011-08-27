class TestController < ActionController::Base
  def test
    @rails = true
    render :text => "<html><body>Hello World</body></html>"
  end
end