class PeopleController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @title = "People | #{configatron.app_name}"
  end
  
  def show
    @user = User.find(params[:id])
    @title = "#{@user.display_name} | #{configatron.app_name}"
  end
  
  def friends
    @user = User.find(params[:id])
    @title = "#{@user.display_name}'s friends | #{configatron.app_name}"
    
    auth = @user.authentications.select{ |a| a.provider == 'facebook' }.compact.first
    graph_api = Koala::Facebook::API.new(auth.access_token)
    fields = 'id, name, first_name, last_name, link, picture'
    @friends = graph_api.get_connections("me", "friends", :fields => fields, :limit => 10, :offset => 0)
    
    # let them select who they want to send invites to
    # for friends who are already on fnnny (think of the future!), let them follow rather than invite
  end
  
  def invite
    @user = User.find(params[:id])
    
    # invite_fb_ids: "invite_fb_ids"=>["713135", "842025"]
    logger.debug "params: #{params.inspect}"
    
    # record invitees in 'invites' table: user_id, invitee_fb_id
    
      # a given user should probably only be able to invite someone once.
      # you can check new users against 'invites,' and auto-folloer the inviter
      
    # get names of invitees from fb. email addresses , if you can
    # (or message them through fb?)
    
    # 
    
    # send invites. async eventually.
    
    
  end
  
  def follow
    if signed_in?
      @user = User.find(params[:id])
      current_user.follow(@user)
      
      # TODO: async this
      UserMailer.new_follow_email(current_user, @user).deliver
      
      render :partial => "people/follow"
    end
  end
  
  def unfollow
    if signed_in?
      @user = User.find(params[:id])
      current_user.stop_following(@user)
      render :partial => "people/follow"
    end
  end
  
end
