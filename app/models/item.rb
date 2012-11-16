class Item < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include PublicActivity::Model
  
  attr_accessible :description, :latitude, :location, :longitude, :name, :url, :original_img_url, :small_img_url, :medium_img_url, :large_img_url, :square_img_url, :user_id
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  tracked :owner => proc { |controller, model| controller.current_user }
  acts_as_taggable
  acts_as_voteable
  
  belongs_to :user
  has_many :comments, :as => :commentable
  
  before_destroy :delete_from_cloudinary
  
  def delete_from_cloudinary
    Cloudinary::Uploader.destroy( self.id )
  end
  
  def display_name
    if name.present?
      name
    else
      url.gsub('http://', '').gsub('www.', '').gsub(/\/*$/, '')
    end
  end
  
end
