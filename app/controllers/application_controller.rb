class ApplicationController < ActionController::Base
  include PublicActivity::StoreController 
  
  protect_from_forgery
  
  helper :all
  
  before_filter :canonicalize
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def canonicalize
    if Rails.env == 'production'
      redirect_to 'http://www.fnnny.com' if request.host == 'fnnny.com'
    end
  end
  
  def after_sign_in_path_for(resource)
    if resource.authentications.present?
      # request.env['omniauth.origin'] || stored_location_for(resource) || root_path
      friends_person_path(resource)
    else
      root_path
    end
  end
  
  def require_admin
    unless current_user.admin?
      redirect_to root_path, :alert => 'noooooo no no no no. no.'
    end
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  end
  
end
