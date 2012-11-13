class BankController < ApplicationController
  
  def withdraw
    
    ######################################################
    #  PUBLIC KEY RETRIEVAL ##############################
    ######################################################
    
    # This key was PRE-GENERATED; can be changed, but ALL coins will encrypted with the same RSA public key.
    
    key = RsaKey.find(1)
    @rsa_public_key = key.public_key
    @rsa_private_key = key.private_key
    
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
    @denomination = 50
    
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
    
    # Reveal identity (from key 12)
    @identity_revealed = [(@identity_keys[11].to_i(16) ^ @identity_xored_keys[11].to_i(16)).to_s(16)].pack('H*')
    
    
    # Generate 12-bit (3)
     
    @bit_string = ((SecureRandom.hex(2)).hex).to_s(2)
    
    if @bit_string.length < 16
      @bit_string = @bit_string.center(16, "0")
    end
    
    # Get appropriate half if 0 or 1
    @identity_half = Hash.new
    
    for i in 0..15
      if @bit_string[i] == '1'
        @identity_half[i] = @identity_xored_keys[i]
      else
        @identity_half[i] = @identity_keys[i]
      end
    end
    
    render 'index'
  end
  
  def deposit
    
  end
  
end
