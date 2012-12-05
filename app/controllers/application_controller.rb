class ApplicationController < ActionController::Base
  include PublicActivity::StoreController 
  
  protect_from_forgery
  
  def after_sign_in_path_for(resource)
    # request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    friends_person_path(resource)
  end
    
end
