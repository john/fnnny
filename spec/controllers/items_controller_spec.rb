require 'spec_helper'

describe ItemsController do
  
  describe "logged-in user, non-admin" do
    
    before(:each) do
      @current_user = FactoryGirl.create(:user)
      @current_user.email = "imnotanadmin@phubhar.com"
      @controller.stub!(:current_user).and_return(@current_user)
    end
    
    it "redirects the index page" do
      get :index
      response.should be_redirect
    end
    
    it "can view items" do
      item = FactoryGirl.create(:item)
      
      get :show, :id => item.id
      response.should be_success
      response.should render_template :show
      response.should render_template "layouts/application"
    end
    
    it "can view the new item page" do
      @controller.stub!(:authenticate_user!).and_return(true)
      
      get :new
      response.should be_success
      response.should render_template :new
      response.should render_template "layouts/application"
    end
    
  end
  
  describe "logged-in user, admin" do
    
    before(:each) do
      @current_user = FactoryGirl.create(:user)
      @controller.stub!(:current_user).and_return(@current_user)
    end
    
    it "loads the index page" do
      @controller.stub!(:authenticate_user!).and_return(true)
      
      get :index
      response.should be_success
      response.should render_template :index
      response.should render_template "layouts/application"
    end
    
  end
  
end
