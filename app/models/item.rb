class Item < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessible :description, :latitude, :location, :longitude, :name, :url, :original_img_url, :small_img_url, :medium_img_url, :large_img_url, :square_img_url, :user_id
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  acts_as_taggable
  acts_as_voteable
  
  belongs_to :user
  
end
