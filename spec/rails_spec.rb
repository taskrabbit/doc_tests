require "spec_helper"

describe TestController, :type => :controller do
  it "should integrate Rails" do
    get :test
    response.should be_success
    assigns[:rails].should be_true
  end
end