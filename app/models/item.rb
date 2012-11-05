class Item < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessible :description, :latitude, :location, :longitude, :name, :url, :user_id
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  acts_as_taggable
  
  belongs_to :user
  
end
