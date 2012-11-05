class Authentication < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  attr_accessible :provider, :token, :uid, :user_id, :access_token, :access_token_secret
  
  belongs_to :user
  
end
