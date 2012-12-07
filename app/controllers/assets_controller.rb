class AssetsController < ApplicationController
  
  before_filter :authenticate_user
  
  def index
    
    # For populating drop-down menu
    @account_holders = User.find(:all, :select => 'id, username', :conditions => ["users.id != ?", current_user.id])

    
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
  
  def verify_coin
      key = RsaKey.find(1)
      pub_key = RSA::Key.new((key.modulus).to_i, (key.encryption).to_i)
      pri_key = RSA::Key.new((key.modulus).to_i, (key.decryption).to_i)
      k = RSA::KeyPair.new(pri_key, pub_key)
      
      keys = Hash.new
      
      for i in 0..15
        keys[i] = Key.find_by_serial_and_identity_num(params[:serial], i)
      end
      
      @serial = params[:serial]
      
      @verify_key_hash = Hash.new
      @verify_msgxor_hash = Hash.new
      
      @always_true = false
      
      for i in 0..15
        @verify_key_hash[i] = k.verify(keys[i].signed_key, keys[i].key)
        @verify_msgxor_hash[i] = k.verify(keys[i].signed_msg_xor_key, keys[i].msg_xor_key)
      
        temp = (@verify_key_hash[i] == true) &&  (@verify_msgxor_hash[i] == true)
        @always_true = (temp == true)      
      end
      
      respond_to do | format |
        format.html   { redirect_to assets_path }
        format.js { [@always_true, @serial] }
      end
      
  end
  
end
