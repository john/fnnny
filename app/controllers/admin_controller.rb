class AdminController < ApplicationController
  
  before_filter :require_admin
  
  def index
    @title = "Admin : #{configatron.app_name}"
    
  end
  
end
