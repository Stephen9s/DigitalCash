class CheckingAccount < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :owner_id, :amount
  
end
