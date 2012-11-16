class CommentsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    if params[:message]
      
      # { message: commentQuery.value[0].text, fb_id: response.commentID, from_id: commentQuery.value[0].fromid, object_id: commentQuery.value[0].object_id, post_id: commentQuery.value[0].post_id, commentable_id: "#{@item.id}", commentable_type: "#{@item.class.to_s}" }, function(data) {
      
      
      Comment.create!(  :user_id => current_user.id,
                        :message => params[:message],
                        :fb_id => params[:fb_id],
                        :from_id => params[:from_id],
                        :object_id => params[:object_id],
                        :post_id => params[:post_id],
                        :commentable_id => params[:commentable_id],
                        :commentable_type => params[:commentable_type],
                        :fb_create_time => params[:fb_create_time],
                        :user_likes => params[:user_likes],
                        :like_count => params[:like_count] )
                        
      render :nothing => true
    end
  end
  
end
