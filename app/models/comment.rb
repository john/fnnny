class Comment < ActiveRecord::Base
  include PublicActivity::Model
  
  attr_accessible :user_id, :fb_create_time, :fb_id, :from_id, :like_count, :message, :user_likes, :object_id, :post_id, :commentable_id, :commentable_type
  
  tracked :only => [:create], :owner => proc { |controller, model| controller.current_user if controller.present? }
  
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user
  
end
