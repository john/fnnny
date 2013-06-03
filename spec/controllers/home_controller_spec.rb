require 'spec_helper'

describe HomeController do
  
  describe "logged-in user" do
    
    before(:each) do
      @current_user = FactoryGirl.create(:user)
      @controller.stub!(:current_user).and_return(@current_user)
    end
    
    it "loads the homepage" do
      get :index
      response.should be_success
      response.should render_template :index
      response.should render_template "layouts/application"
    end
    
    it "loads the bookmarklet install page" do
      get :bookmarklet
      response.should be_success
      response.should render_template :bookmarklet
      response.should render_template "layouts/application"
    end
    
  end
  
end
