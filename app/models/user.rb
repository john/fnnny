class User < ActiveRecord::Base
  # include ActiveModel::ForbiddenAttributesProtection
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :authentications, :dependent => :delete_all
  has_many :items, :order => 'created_at DESC'
  
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  
  acts_as_tagger
  acts_as_follower
  acts_as_followable
  acts_as_messageable
  acts_as_voter
  has_karma(:items, :as => :user, :weight => 0.5)
  
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        
        if session["devise.auth_attributes"]
          auth = session["devise.auth_attributes"]
          user.authentications.build(   :provider => auth[:provider],
                                        :uid => auth[:uid],
                                        :access_token => auth[:access_token],
                                        :access_token_secret => auth[:access_token_secret])
        end
        user.valid?
      end
    else
      super
    end
  end
  
  def from_omniauth(auth, remote_ip=nil)
    self.sign_in_count += 1
    self.current_sign_in_at = Time.now
    self.last_sign_in_at = Time.now
    self.current_sign_in_ip =  remote_ip
    self.last_sign_in_ip = remote_ip
    
    if auth['info']
      self.first_name = auth['info']['first_name'] if auth['info']['first_name']
      self.last_name = auth['info']['last_name'] if auth['info']['last_name']
      self.email = auth['info']['email'] if auth['info']['email'] # Google, Yahoo, GitHub
    end
    
    authentications.build(  :provider => auth['provider'],
                            :uid => auth['uid'],
                            :access_token => auth['credentials']['token'],
                            :access_token_secret => auth['credentials']['secret'])
  end
  
  def password_required?
    logger.debug "authentications: #{authentications.inspect}"
    if authentications.blank? || authentications.first.provider.blank?
      super
    end
  end
  
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def display_name
    full_name.blank? ? email : full_name
  end
  
  # for 
  
  def display_first_name
    if first_name.present?
      first_name
    elsif last_name.present?
      last_name
    else
      email
    end
  end
  
end
