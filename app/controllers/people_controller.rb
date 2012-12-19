class PeopleController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @title = "People | #{configatron.app_name}"
    @people = User.paginate(:page => params[:page])
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
    @friends = graph.get_connections("me", "friends", :fields => 'picture', :limit => 50, :offset => 0)
  end
  
  def follow
    if signed_in?
      @user = User.find(params[:id])
      current_user.follow(@user)
      
      # TODO: async this
      # follow_mail = UserMailer.new_follow_email(current_user, @user) #.deliver
      
      # queue = fetch('/queues/mailer')
      # queue.publish {:email => 'new_follow', :current_user => current_user, :new_follower => @user}
      EmailQueue.enqueue(:send_email, {
        :type => :new_follow,
        :current_user => current_user,
        :new_follower => @user
      })
      
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
