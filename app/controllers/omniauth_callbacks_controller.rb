class OmniauthCallbacksController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    omni_params = request.env['omniauth.params']
    
    logger.debug "-------------------> omni_params: #{omni_params.inspect}"
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
      
      if user.persisted?
        
        # TODO: async this soon.
        UserMailer.welcome_email(user).deliver
        
        if omni_params['request_ids']
          # hit fb api for SEND_USER_ID
          
          @graph = Koala::Facebook::API.new( auth['credentials']['token'] )
          
          omni_params['request_ids'].split(',').each do |request_id|
            request = @graph.get_object( request_id )
            logger.debug "-----------------> request: #{request.inspect}"
            # per fb docs, response should look something like this:
            # {
            #   "id": "REQUEST_OBJECT_ID", 
            #   "application": {
            #     "name": "APP_DISPLAY_NAME", 
            #     "canvas_name": "APP_NAME",  // This is identical to the app namespace
            #     "namespace": "APP_NAMESPACE", 
            #     "id": "APP_ID"
            #   },
            #   "to": {
            #     "name": "RECIPIENT_USER_NAME", 
            #     "id": "RECIPIENT_USER_ID"
            #   }, 
            #   "from": {
            #     "name": "SENDER_USER_NAME", 
            #     "id": "SEND_USER_ID"
            #   }, 
            #   "message": "Check out this Awesome Request!", 
            #   "created_time": "2012-01-24T00:43:22+0000", 
            #   "type": "apprequest"
            # }

            # get SEND_USER_ID
            
            logger.debug "---------request['to']['id']: #{request['from']['id']}"
            
            inviter_auth = Authentication.find_by_uid( request['from']['id'] )
            inviter = inviter_auth.user
            user.follow( inviter )
            inviter.follow( user )
          
            # TODO: async this
            # new_follow_email(user, follower)
            UserMailer.new_follow_email(inviter, user).deliver
          end
        
        end
        
        
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