class Invite < ActiveRecord::Base
  attr_accessible :request_id, :state, :to_id, :user_id
end
