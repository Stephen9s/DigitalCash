class AssetsController < ApplicationController
  
  before_filter :authenticate_user
  
  def index
    
    # For populating drop-down menu
    @account_holders = User.find(:all, :select => 'id, username')

    
    begin 
      @account = CheckingAccount.find_by_owner_id(current_user.id)  
      
    rescue ActiveRecord::RecordNotFound
      @account = []
      
    end
    
    begin 
      @coins = Purse.find_all_by_owner_id(current_user.id)  
      
    rescue ActiveRecord::RecordNotFound
      @coins = []
      
    end
    
    begin 
      @coins_received = Purse.where("owner_id != ? AND recipient_id = ?", current_user.id, current_user.id)
      
    rescue ActiveRecord::RecordNotFound
      @coins_received = []
      
    end
    
  end
  
  # Method to provide data to the send page to select an account holder to whom we will send a coin!
  def transfer_hands
    retrieve_coin = Purse.find_by_owner_id_and_serial(current_user.id, params[:coin][:serial])
    retrieve_coin.recipient_id = params[:coin][:recipient_id]
    
    if retrieve_coin.save
      redirect_to assets_path
    else
      render 'transfer_hands'
    end
    
  end
  
end
