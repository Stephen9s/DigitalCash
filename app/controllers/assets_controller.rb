class AssetsController < ApplicationController
  
  #require 'active_support/secure_random'
  
  def index
    
    begin 
      @account = CheckingAccount.find_by_owner_id(current_user.id)  
      
    rescue ActiveRecord::RecordNotFound
      @account = []
      
    end
    
    begin 
      @coins = Purse.find_all_by_owner_id_and_recipient_id(current_user.id, 0)  
      
    rescue ActiveRecord::RecordNotFound
      @coins = []
      
    end
    
    begin 
      @coins_received = Purse.where("owner_id != ? AND recipient_id = ?", current_user.id, current_user.id)
      
    rescue ActiveRecord::RecordNotFound
      @coins_received = []
      
    end
  end
end
