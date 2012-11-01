class Item < ActiveRecord::Base
  attr_accessible :description, :latitude, :location, :longitude, :name, :url, :user_id, :tag_list
  
  belongs_to :user
  
  acts_as_taggable
  
end
