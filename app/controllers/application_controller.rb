class ApplicationController < ActionController::Base
  include PublicActivity::StoreController 
  
  protect_from_forgery
  
  helper :all
  
  def after_sign_in_path_for(resource)
    # request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    friends_person_path(resource)
  end
  
  def require_admin
    unless current_user.admin?
      redirect_to root_path, :alert => 'noooooo no no no no. no.'
    end
  end
  
end
