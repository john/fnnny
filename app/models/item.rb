# Add model: adds
# User has_many :adds
# User has_many :items, :through => :adds
# :add gets comments, images, does it also get activity?
# like repos, items for a specific user maybe should be addressed through them. also directly?
# - /people/john/overhead-in-new-york
# - /items/overheard-in-new-york

# rails g model add user_id:integer item_id:integer slug:string :...

# or maybe Item stays just as it is, and URL gets turned into its own model ('Link'?) 

require "addressable/uri"

class Item < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include PublicActivity::Model
  
  attr_accessible :description, :latitude, :location, :longitude, :name, :url, :image, :image_cache, :original_image_url, :user_id, :tag_list, :comments_count
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  tracked :only => [:create], :owner => proc { |controller, model| controller.current_user if controller.present? }
  acts_as_taggable
  acts_as_voteable
  
  belongs_to :user
  has_many :comments, :as => :commentable
  
  before_destroy :delete_from_cloudinary
  
  mount_uploader :image, ImageUploader
  
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
  
  def belongs_to(user)
    if self.user_id == user.id
      true
    else
      redirect_to root_path, :alert => 'Not fnnny.'
    end
  end
  
  def youtube?
    url.present? && url.include?('youtube.com/watch')
  end
  
  def embed_url
    params_hash = Rack::Utils.parse_query( Addressable::URI.parse( url ).query )
    "http://www.youtube.com/embed/#{params_hash['v']}"
  end
  
end
