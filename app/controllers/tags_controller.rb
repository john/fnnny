class TagsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
  end
  
  def show
    # @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @items = Item.tagged_with(params[:id]) #.by_date.paginate(:page => params[:page], :per_page => 20)
    
    @title = "#{params[:id]} | #{configatron.app_name}"
  end
  
  # def follow
  #   if signed_in?
  #     @user = User.find(params[:id])
  #     current_user.follow(@user)
  #     render :partial => "people/follow"
  #   end
  # end
  # 
  # def unfollow
  #   if signed_in?
  #     @user = User.find(params[:id])
  #     current_user.stop_following(@user)
  #     render :partial => "people/follow"
  #   end
  # end
  
end