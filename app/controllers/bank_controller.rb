class BankController < ApplicationController
  
  before_filter :authenticate_user
  
  def index
    
  end
  
  def withdraw
    
    ######################################################
    #  PUBLIC KEY RETRIEVAL ##############################
    ######################################################
    
    # This key was PRE-GENERATED; can be changed, but ALL coins will encrypted with the same RSA public key.
    
    key = RsaKey.find(1)
    pub_key = RSA::Key.new((key.modulus).to_i, (key.encryption).to_i)
    pri_key = RSA::Key.new((key.modulus).to_i, (key.decryption).to_i)
    k = RSA::KeyPair.new(pri_key, pub_key)
    
    ######################################################
    #  RANDOM SERIAL #####################################
    ######################################################

    @random_string = SecureRandom.hex(3)
    
    # Check if serial number exists in purse
      @purse_serial = Purse.find_by_serial(@random_string)

      if @purse_serial != nil
        
        while @purse_serial != nil do
          
            logger.info("Serial number exists:" + @random_string)
            @random_string = SecureRandom.hex(3)
            @purse_serial = Purse.find_by_serial(@random_string)
            
        end
        
      end
      
      # Check if serial exists in bank
      serial_in_bank = DepositedCoin.find_by_serial(@random_string)

      # If serial in bank EXISTS
      if serial_in_bank != nil
        
        # Continue regenerating serial until the serial cannot be found in the bank
        while serial_in_bank != nil do
          
            logger.info("Serial number exists in bank:" + @random_string)
            @random_string = SecureRandom.hex(3)
            serial_in_bank = DepositedCoin.find_by_serial(@random_string)
            
        end
        
      end
    
    # The serial should be unique now
    
    # Convert serial number to binary (guaranteed unique)
      @random_string_binary = (@random_string.hex).to_s(2)
      
    
    ######################################################
    #  DEMONINATION ######################################
    ######################################################
    
    # We should retrieve the denomination from a form, but we can set it statically here
    @denomination = params[:denomination]
    
    ######################################################
    #  FIND IDENTITY STRING ##############################
    ######################################################
    
    @user_info = User.find(current_user.id, :select => 'username, f_name, l_name, address, phone_num, dob, gender')
    @identity_string = "#{@user_info.username}.#{@user_info.f_name}.#{@user_info.l_name}.#{@user_info.address}.#{@user_info.phone_num}.#{@user_info.dob}.#{@user_info.gender}"
    
    # Convert to hex
    @hex_string = @identity_string.unpack('H*')
    
    @hex_string_to_str = @hex_string.join("")
    @hex_string_count = @hex_string_to_str.length
    
    # If identity string hex length < 100, pad it with A.
    if (@hex_string_count < 100)
      @hex_string_to_str = @hex_string_to_str.center(100, "A")
    end
    
    # Repack hex string to see if everything is OK...
    @hex_string_packed = [@hex_string_to_str].pack('H*')
    
    # Generate hash with keys for each identity
    @identity_keys = Hash.new
    
    for i in 0..15
      @identity_keys[i] = SecureRandom.hex(50)
    end
    
    # Message XOR Key Hash
    @identity_xored_keys = Hash.new
    
    for i in 0..15
      @identity_xored_keys[i] = (@identity_keys[i].to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    end
    
    ##########################################
    #       DATABASE ENTRIES    ##############
    ##########################################
    
    
    # Create new purse item
    Purse.create(:owner_id => current_user.id, :recipient_id => 0, :serial => @random_string, :denomination => @denomination)
    
    # Save keys to database
    for i in 0..15
      Key.create(:serial => @random_string, :identity_num => i, :key => @identity_keys[i], :msg_xor_key => @identity_xored_keys[i],
      :signed_key => k.sign(@identity_keys[i]), :signed_msg_xor_key => k.sign(@identity_xored_keys[i]))
    end
    
    
    # Generate 16-bit (2)
     
    @bit_string = ((SecureRandom.hex(2)).hex).to_s(2)
    
    # This'll pad the 16-bit generator if the random hex string is less than 16 bits (leading zeroes are usually truncated)
    if @bit_string.length < 16
      @bit_string = @bit_string.center(16, "0")
    end
    
    # Get appropriate half if 0 or 1
    @identity_half = Hash.new
    @identity_half_signature = Hash.new
    @identity_half_signature_verified = Hash.new
    
    for i in 0..15
      # msg_xor_key
      if @bit_string[i] == '1'
        @identity_half[i] = @identity_xored_keys[i]
        @identity_half_signature[i] = k.sign(@identity_xored_keys[i])
        @identity_half_signature_verified[i] = k.verify(@identity_half_signature[i], @identity_xored_keys[i])
      else
        @identity_half[i] = @identity_keys[i]
        @identity_half_signature[i] = k.sign(@identity_keys[i])
        @identity_half_signature_verified[i] = k.verify(@identity_half_signature[i], @identity_keys[i])
      end
    end
    
    
    
    ############################
    # PULL COIN FROM KEY TABLE #
    ############################
    
    coin_keys = Key.find_all_by_serial(@random_string)
    
    coin_keys.each do |coin_key|
      left_half = coin_key.key
      right_half = coin_key.msg_xor_key
    
      # No longer need to decrypt
      #left_half = k.decrypt(left_half)
      #right_half = k.decrypt(right_half)
    
      @identity_revealed = [(left_half.to_i(16) ^ right_half.to_i(16)).to_s(16)].pack('H*')
      
    end
    
    
  end
  
  def deposit
    
    if params[:coin]
      
      retrieved_keys = Key.find_all_by_serial(params[:coin][:serial])

      ##############################
      #  GENERATE BIT STRING       #
      ##############################
      
      @bit_string = ((SecureRandom.hex(2)).hex).to_s(2)
      
      # This'll pad the 16-bit generator if the random hex string is less than 16 bits (leading zeroes are usually truncated)
      if @bit_string.length < 16
        @bit_string = @bit_string.center(16, "0")
      end
      
      #############################
      # GET HALVES, PUT IN TEMP   #
      #############################
      
      i = 0
      
      # Indexed hashed
      temp_coin_with_half_keys = Hash.new
      
      retrieved_keys.each do |key|
        
        if @bit_string[i] == '1'
          temp_coin_with_half_keys[i] = TempTransaction.new(:serial => key.serial, :identity_num => key.identity_num, :identity_half => key.msg_xor_key, :signed_half => key.signed_msg_xor_key)
        else
          temp_coin_with_half_keys[i] = TempTransaction.new(:serial => key.serial, :identity_num => key.identity_num, :identity_half => key.key, :signed_half => key.signed_key)
        end
        
        i = i + 1
        
      end

      
      ##############################
      #  CHECK IF SERIAL EXISTS    #
      ##############################
      serial_exists = DepositedCoin.find_by_serial(params[:coin][:serial])

      if serial_exists
        
        key = RsaKey.find(1)
        pub_key = RSA::Key.new((key.modulus).to_i, (key.encryption).to_i)
        pri_key = RSA::Key.new((key.modulus).to_i, (key.decryption).to_i)
        k = RSA::KeyPair.new(pri_key, pub_key)
        
        keys_that_bank_has = DepositedCoinsKey.find_all_by_serial(params[:coin][:serial])
        
        
        @xored_hash = Hash.new
        @verify_half_hash = Hash.new
        
        @ZOMGHACKER = "HACKS"
        
        i = 0
        
        #@identity_revealed = [(left_half.to_i(16) ^ right_half.to_i(16)).to_s(16)].pack('H*')
        
        if serial_exists.flag == 0
          
          keys_that_bank_has.each do |key_that_bank_has|
            
            @xored_hash[i] = [(key_that_bank_has.identity_half.to_i(16) ^ (temp_coin_with_half_keys[i].identity_half).to_i(16)).to_s(16)].pack('H*')
            @verify_half_hash[i] = k.verify(temp_coin_with_half_keys[i].signed_half, temp_coin_with_half_keys[i].identity_half)
            
            if @xored_hash[i].size == 1
              @xored_hash[i] = "NO INFO"
            end
            
            key_that_bank_has.identity_half = @xored_hash[i]
            key_that_bank_has.save
            
            i += 1
            
          end
          
          serial_exists.flag = 1
          serial_exists.save
          
          retrieve_coin = Purse.find_by_serial(params[:coin][:serial])
          retrieve_coin.recipient_id = 0
          retrieve_coin.save
          
        else
          hacker_found = DepositedCoinsKey.find_all_by_serial(params[:coin][:serial])
          
          i = 0
          
          hacker_found.each do |hacker|
            @xored_hash[i] = hacker.identity_half
            
            i += 1
          end
          
        end
        
      else
        purse_coin = Purse.find_by_serial(params[:coin][:serial], :select => "denomination")
        deposited_coin = DepositedCoin.create(:serial => params[:coin][:serial], :amount => purse_coin.denomination)
        # flag is set to 0 automatically
        
        # Deposit hashes into permanent table
        
        for i in 0..15
          h = DepositedCoinsKey.create(:serial => temp_coin_with_half_keys[i].serial, :identity_num => temp_coin_with_half_keys[i].identity_num, :identity_half => temp_coin_with_half_keys[i].identity_half)
        end
        
      end
      
      #############################
      # DESTRUCTION METHODS HERE  #
      #############################
      
      #retrieved_keys.each { |o| o.destroy }
      
    else
      redirect_to assets_path
    end
    
   
  end
  
end
