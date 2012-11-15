class Purse < ActiveRecord::Base
  
  attr_accessible :owner_id, :recipient_id, :serial, :denomination
  
  has_many :keys
  
end
