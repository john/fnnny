class HomeController < ApplicationController

  def index
    # @title = "#{configatron.app_name}: To delight and amuse"
    @title = "#{configatron.app_name}. You will laugh now."
    # @title = "#{configatron.app_name}. Laugh you donkey laugh"
    # @title = "#{configatron.app_name}. Quora for Idiots."
    # @title = "#{configatron.app_name}. Mo fnnny mo better."
    # @title = "#{configatron.app_name}. The best site on the Internet... for donkies."
    # @title = "#{configatron.app_name}. Enterprise Humor Portal."
    # @title = "#{configatron.app_name}. So three guy walk into a bar..."
    
    # El quatro oh quatro: the Intenet joke machine.
    
    
    if signed_in?
      
      following_count = current_user.following_by_type_count('User')
      if following_count > 0
        @followers = true
        if params[:show]
          # if there's a show param, respect it, if you can
          if params[:show] == 'followers'
            @show_followers = true
          elsif params[:show] == 'all'
            @show_all = true
          else
            @show_followers = true
          end
        else
          if following_count > 1
            # if not, default to followers if you're following 3 or more people
            @show_followers = true
          else
            # otherwise to all
            @show_all = true
          end
        end
      else
        # if no followers, have to show all
        @show_all = true
      end
      
      @people = User.order("created_at DESC").limit(5)
      
      
      # only get activities for you and your followers
      @activities = PublicActivity::Activity.order("created_at DESC").limit(10)
      
      if @show_followers
        # get all items created by the people you're following
        # adapted from: http://stackoverflow.com/questions/7920082/get-posts-of-followed-users-with-acts-as-follower
        # @items = current_user.following_users.includes(:items).collect{|u| u.items}.flatten
        
        @items = Item.find_by_sql("SELECT i.* FROM items i WHERE i.user_id IN (SELECT followable_id FROM follows WHERE followable_type = 'User' AND follower_type = 'User' AND follower_id = #{current_user.id}) ORDER BY created_at DESC LIMIT 25")
        
      else
        # add a dismissible banner pushing users to follow people to see scoped results.
        @items = Item.order('created_at DESC').limit(20) # where("user_id != ?", current_user.id).
        
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
