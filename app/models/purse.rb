class Purse < ActiveRecord::Base
  
  attr_accessible :owner_id, :receiver_id, :serial, :denomination
  
end
