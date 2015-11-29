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
  
  PER_PAGE = 5
  
  attr_accessible :description, :latitude, :location, :longitude, :name, :url, :image, :image_cache, :original_image_url, :user_id, :tag_list, :comments_count, :post_to_fb
  
  tracked :only => [:create], :owner => proc { |controller, model| controller.current_user if controller.present? }
  acts_as_taggable
  acts_as_voteable
  
  belongs_to :user
  has_many :comments, :as => :commentable
  
  before_destroy :delete_from_cloudinary
  
  mount_uploader :image, ImageUploader
  
  
  def find_images
    uri = Addressable::URI.parse(url)
    pre = "#{uri.scheme}://#{uri.host}"
    
    doc = Nokogiri::HTML(open(url))
    images = doc.search('img')
    @out = []
    
    images.each do |image|
      
      uri, src, size, width, height = nil, nil, nil, nil, nil
      
      if image['data-src'].present?
        src = image['data-src']
      else
        src = image['src']
      end
      puts "---> src: #{src}"
      
      unless src.include?('doubleclick')
        if (src[0] == '/') && (src[1] != '/')
          uri = "#{pre}#{src}"
        elsif src[0..3] == 'http'
          uri =  src
        end
      end
      puts "---> uri: #{uri}"
      
      if uri.present? && src.present?
        size = FastImage.size(uri)
        if size.kind_of?(Array)
          width = size[0]
          height = size[1]
          if uri.present? && width > 64 && height > 64
            @out << uri
          end
        end
      end
    end
    
    @out.uniq
  end
  
  
  
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
  
  def belongs_to?(user)
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
  
  def upvoters(args={})
    args.reverse_merge! :limit => 10, :order => 'updated_at DESC'
    
    votes.where(:vote => 1).limit(args[:limit]).order(args[:order]).map{|vote| User.find(vote.voter_id) }
  end
  
end
