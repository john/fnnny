class HomeController < ApplicationController

  def index
    # @title = "#{configatron.app_name}: To delight and amuse"
    @title = "#{configatron.app_name}. You will laugh now."
    
    if signed_in?
      @activities = PublicActivity::Activity.order("created_at DESC").limit(10)
      
      if current_user.following_by_type_count('User') >= 3
        # get all items created by the people you're following
        # adapted from: http://stackoverflow.com/questions/7920082/get-posts-of-followed-users-with-acts-as-follower
        @items = User.find(current_user.id).following_users.includes(:items).collect{|u| u.items}.flatten
        
      else
        # add a dismissible banner pushing users to follow people to see scoped results.
        @items = Item.where("user_id != ?", current_user.id).order('created_at DESC').limit(20)
        
      end
    end
    
  end
  
  def bookmarklet
    respond_to do |format|
      format.html
      format.js
    end
  end
  
end
