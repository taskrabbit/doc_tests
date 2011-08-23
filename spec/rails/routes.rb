ActionController::Routing::Routes.draw do |map|
  map.connect "test/:action", :controller => "test"
end