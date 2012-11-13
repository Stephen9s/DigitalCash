class AssetsController < ApplicationController
  
  #require 'active_support/secure_random'
  
  def index
    
    begin 
      @account = CheckingAccount.find_by_owner_id(current_user.id)  
      
    rescue ActiveRecord::RecordNotFound
      @account = []
      
    end
    
  end
end
