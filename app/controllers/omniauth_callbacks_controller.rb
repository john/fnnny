class OmniauthCallbacksController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    
    logger.debug '--------------------------'
    logger.debug 'request.env["omniauth.auth"]'
    logger.debug request.env["omniauth.auth"]
    logger.debug '--------------------------'
    
    # #<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash expires=true expires_at=1453833662 token="CAAEMzrPeq5YBAHSS5MboVZCZCHzOAyUB7y3Q5GYJeumVz1OXxFxyqxUbz05GEvpxMGfjpdZBE8sQPjcn3APqrjkSiTUTnncZCkPirEQXMbCHfEDwJwqKMiOQCWtvqG6iP1iZB3ICJRBCMjH6a9NZAudD0YKuzWhDtYIyQxdfmC5Tm92ShAV8XW94fE5BAYpEAbcyXZAZCCWntgZDZD"> extra=#<OmniAuth::AuthHash raw_info=#<OmniAuth::AuthHash email="john@entelo.com" id="675003241" name="John McGrath">> info=#<OmniAuth::AuthHash::InfoHash email="john@entelo.com" image="http://graph.facebook.com/675003241/picture" name="John McGrath"> provider="facebook" uid="675003241">
    
    # so, available:
    # auth['info']['email']
    # auth['info']['image']
    # auth['info']['name']
    # auth['info']['provider']
    # auth['info']['uid']
    
    omni_params = request.env['omniauth.params']
    
    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    
    if authentication
      # Authentication found, sign the user in.
      # sign_in_and_redirect authentication.user, :notice => "Signed in successfully."
      sign_in authentication.user
      redirect_to root_path, :notice => "Signed in successfully."
      
    else
      # Authentication not found, thus a new user.
      user = User.new
      user.from_omniauth(auth, request.remote_ip)
      user.save
      
      if user.persisted?
        user.send_welcome_email
        
        # THIS was already implemented below. Do we want to change invite state
        # if invites = Invite.where(:to_id => auth['uid'])
        #   invites.each do |i|
        #     inviter = i.user
        #     inviter.follow(user)
        #     user.follow(inviter)
        #     inviter.send_follow_email(user)
        #     user.send_follow_email(inviter)
        #   end
        # end
        
        # inviter and invitee should follow each other
        if omni_params['request_ids']
          
          @graph = Koala::Facebook::API.new( auth['credentials']['token'] )
          
          omni_params['request_ids'].split(',').each do |request_id|
            request = @graph.get_object( request_id )
            
            if inviter_auth = Authentication.find_by_uid( request['from']['id'] )
              inviter = inviter_auth.user
              user.follow( inviter )
              inviter.follow( user )
              
              # TEST that this block is only hit if it finds an auth.
              
              inviter.send_follow_email(user)
              user.send_follow_email(inviter)
              
              @graph.delete_object( request_id )
            end
            
          end
        
        end
        
        # THIS notice doesn't seem to be getting displayed.
        
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