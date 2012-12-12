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
    @title = "#{t(:title_friends, :username => @user.display_name)} | #{configatron.app_name}"
    
    auth = @user.authentications.select{ |a| a.provider == 'facebook' }.compact.first
    graph = Koala::Facebook::API.new(auth.access_token)
    fields = 'picture'
    @friends = graph.get_connections("me", "friends", :fields => fields, :limit => 30, :offset => 0)
    
    # let them select who they want to send invites to
    # for friends who are already on fnnny (think of the future!), let them follow rather than invite
  end
  
  
  # I THINK this is superceded by the fact that we're using FB's request widget directly now.
  # def invite
  #   @user = User.find(params[:id])
  #   auth = @user.authentications.select{ |a| a.provider == 'facebook' }.compact.first
  #   graph = Koala::Facebook::API.new(auth.access_token)
  #   
  #   # invite_fb_ids: "invite_fb_ids"=>["713135", "842025"]
  #   logger.debug "params: #{params.inspect}"
  #   
  #   params[:invitees].each do |invitee_raw|
  #     invitee = invitee_raw.split(',')
  #     invitee_hash = {:user_id => current_user.id, :fb_id => invitee[0], :first_name => invitee[1], :last_name => invitee[2], :link => invitee[3]}
  #     invitee = Invitation.where(invitee_hash)
  #     if invitee.blank?
  #       invitee = Invitation.create!(invitee_hash)
  #       
  #       # UserMailer.invite_email(current_user, invitee).deliver
  #       
  #       # # http://rubydoc.info/github/arsduo/koala/master/Koala/Facebook/GraphAPIMethods#put_wall_post-instance_method
  #       # graph.put_wall_post("Fnnny is all up in yr wall", {
  #       #                           :name => "Fnnny invite",
  #       #                           :link => 'http://www.fnnny.com/phu',
  #       #                           :caption => 'you are invited, caption',
  #       #                           :description => 'A somewhat longer explanation',
  #       #                           :picture => 'http://www.abevigoda.com/images/abe.jpg'
  #       #                         })
  #       #                         
  #       #                         # for prod/later testing:
  #       #                         # :tartet_id => invitee.fb_id
  #       
  #     else
  #       # This user has already sent this invitation. Ignore it? Let them know?
  #     end
  #   end
  #   
  #   fields = 'id, name, first_name, last_name, link, picture, email'
  #   @friends = graph.get_connections("me", "friends", :fields => fields, :limit => 10, :offset => 0)
  #   
  #   # record invitees in 'invites' table: user_id, invitee_fb_id
  #     # rails g model user_id: integer, fb_id:integer, accepted_at:datetime
  #   
  #     # a given user should probably only be able to invite someone once.
  #     # you can check new users against 'invites,' and auto-folloer the inviter
  #     
  #   # get names of invitees from fb. email addresses , if you can
  #   # (or message them through fb?)
  #   
  #   # send invites. async eventually.
  # end
  
  
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
