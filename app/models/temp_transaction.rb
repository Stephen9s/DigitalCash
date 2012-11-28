class TempTransaction < ActiveRecord::Base
  attr_accessible :serial, :identity_num, :identity_half, :signed_half
end
