class OmniauthCallbacksController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]

    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if authentication
      # Authentication found, sign the user in.
      sign_in_and_redirect authentication.user, :notice => "Signed in successfully."
      
    else
      # Authentication not found, thus a new user.
      user = User.new
      user.from_omniauth(auth, request.remote_ip)
      user.save
      
      # TODO: async this soon.
      UserMailer.welcome_email(user).deliver
      
      if user.persisted?
        # auth = Authentication.find_or_create_from_omniauth(user, omni_auth)
        sign_in_and_redirect user, :notice => "Account created and signed in successfully."
      else
        session["devise.user_attributes"] = user.attributes
        session["devise.auth_attributes"] = {:provider => auth['provider'],
                                :uid => auth['uid'],
                                :access_token => auth['credentials']['token'],
                                :access_token_secret => auth['credentials']['secret']}
        redirect_to new_user_registration_url, :alert => "Error while creating a user account. Please try again."
      end
      
    end
  end
  alias_method :twitter, :create
  alias_method :facebook, :create
  
  def failure
    redirect_to root_path, :alert => "Sorry, that didn't work." and return
  end
  
end