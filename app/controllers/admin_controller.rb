class AdminController < ApplicationController

  def index
    @title = "Admin : #{configatron.app_name}"
    
    if signed_in? && current_user.admin?
      
    else
      redirect_to root_path, :alert => 'noooooo no no'
    end
  end
  
end
