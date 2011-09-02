ActionController::Routing::Routes.draw do |map|
  map.test "test", :controller => "test", :action => "test"
  map.info "info", :controller => "test", :action => "info"
end