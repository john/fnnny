class HomeController < ApplicationController

  def index
    # @title = "#{configatron.app_name}: Our goal is to exceed your expectations"
    # @title = "#{configatron.app_name}: To delight and amuse"
    # @title = "#{configatron.app_name}. You will laugh now"
    # @title = "#{configatron.app_name}. Quora for Idiots"
    @title = "#{configatron.app_name}, the leading Enterprise Humor Mangement System"
    # @title = "#{configatron.app_name}. Mo fnnny mo better"
    # @title = "#{configatron.app_name}. #{t(:title_home).humanize}."
    # @title = "#{configatron.app_name}. Like America's Home Videos, but dumber."
    # @title = "#{configatron.app_name}. So three guy walk into a bar..."
    # @title = "Smells #{configatron.app_name} in here"
    
    # El quatro oh quatro:
    
    # keep this because, even though using same views, only want to show 'add2home' on iphones
    user_agent = UserAgent.parse( request.env["HTTP_USER_AGENT"] )
    @mobile = true #if user_agent.present? && (user_agent.platform == 'iPhone' || (user_agent.mobile? && user_agent.platform == 'Android'))
    
    if signed_in?
      @following_count = current_user.following_by_type_count('User')
      
      if @following_count > 0
        if params[:show]
          if params[:show] == 'everyone'
            @show_all = true
          elsif params[:show] == 'follows'
            @show_all = false
          else
            @show_all = true if @following_count < 5
          end
          
        else
          @show_all = true if @following_count < 5
          
        end
      else
        @show_all = true
      end
      
      if @show_all
        @items = Item.order('created_at DESC').paginate( :page => params[:page], :per_page => Item::PER_PAGE ) # where("user_id != ?", current_user.id).
        
      else
        # get all items created by the people you're following
        # adapted from: http://stackoverflow.com/questions/7920082/get-posts-of-followed-users-with-acts-as-follower
        # @items = current_user.following_users.includes(:items).collect{|u| u.items}.flatten
        @items = Item.find_by_sql("SELECT i.* FROM items i WHERE i.user_id IN (SELECT followable_id FROM follows WHERE followable_type = 'User' AND follower_type = 'User' AND follower_id = #{current_user.id}) ORDER BY created_at DESC LIMIT 25")
        
      end
      
    else
      if params[:request_ids]
        @auth_url = omniauth_authorize_path(User, 'facebook', :request_ids => params[:request_ids])
      else
        @auth_url = omniauth_authorize_path(User, 'facebook')
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
