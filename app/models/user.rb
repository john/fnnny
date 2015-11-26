# require 'get_back'

class User < ActiveRecord::Base
  # extend GetBack::JoJo
  include PublicActivity::Model
  
  # TODO: 'Deploying with JRuby' has a gem-base, cross-container way of doing this
  # include TorqueBox::Messaging::Backgroundable
  # always_background :send_welcome_email, :send_follow_email, :send_comment_email
  
  # include ActiveModel::ForbiddenAttributesProtection
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :slug, :email, :password, :password_confirmation, :remember_me, :current_password, :notifications
  
  tracked :only => [:create], :owner => proc { |controller, model| controller.current_user if controller.present? }
  
  has_many :authentications, :dependent => :delete_all
  has_many :items, :dependent => :delete_all, :order => 'created_at DESC'
  has_many :comments, :dependent => :delete_all
  has_many :invites, :dependent => :delete_all
  
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
  
  def send_welcome_email
    UserMailer.welcome(self).deliver
  end
  # get_back :send_welcome_email, :pool => 3
  
  # Should send an email to @followed, that @follower is now following them
  # @followed.send_follow_email(@follower)
  def send_follow_email(follower)
    
    # UserMailer.follow(followed, follower)
    UserMailer.follow(self, follower).deliver
  end
  # get_back :send_follow_email, :pool => 3
  
  def send_comment_email(comment)
    puts "about to fire usermailer"
    UserMailer.comment(self, comment).deliver
  end
  # get_back :send_comment_email, :pool => 3
  
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
  
  # Returning the email address of the model if an email should be sent for this object (Message or Notification).
  # If no mail has to be sent, return nil.
  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    # return "define_email@on_your.model"
    return email
    #if false
    #return nil
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
  
  def admin?
    if email.present?
      ['john@fnnny.com', 'john@entelo.com'].include?(email.downcase)
    else
      false
    end
  end
  
end
