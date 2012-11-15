class Key < ActiveRecord::Base
  
  attr_accessible :serial, :identity_num, :key, :msg_xor_key
  
  belongs_to :purse
end
