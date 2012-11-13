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
    
     # 100 hex characters generated
    @identity_key_01 = SecureRandom.hex(50)
    @identity_xored_key_01 = (@identity_key_01.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_02 = SecureRandom.hex(50)
    @identity_xored_key_02 = (@identity_key_02.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_03 = SecureRandom.hex(50)
    @identity_xored_key_03 = (@identity_key_03.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_04 = SecureRandom.hex(50)
    @identity_xored_key_04 = (@identity_key_04.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_05 = SecureRandom.hex(50)
    @identity_xored_key_05 = (@identity_key_05.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_06 = SecureRandom.hex(50)
    @identity_xored_key_06 = (@identity_key_06.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_07 = SecureRandom.hex(50)
    @identity_xored_key_07 = (@identity_key_07.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_08 = SecureRandom.hex(50)
    @identity_xored_key_08 = (@identity_key_08.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_09 = SecureRandom.hex(50)
    @identity_xored_key_09 = (@identity_key_09.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_10 = SecureRandom.hex(50)
    @identity_xored_key_10 = (@identity_key_10.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_11 = SecureRandom.hex(50)
    @identity_xored_key_11 = (@identity_key_11.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_12 = SecureRandom.hex(50)
    @identity_xored_key_12 = (@identity_key_12.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_13 = SecureRandom.hex(50)
    @identity_xored_key_13 = (@identity_key_13.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_14 = SecureRandom.hex(50)
    @identity_xored_key_14= (@identity_key_14.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_15 = SecureRandom.hex(50)
    @identity_xored_key_15 = (@identity_key_15.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    @identity_key_16 = SecureRandom.hex(50)
    @identity_xored_key_16 = (@identity_key_16.to_i(16) ^ @hex_string_to_str.to_i(16)).to_s(16)
    
    
    # Reveal identity (from key 12)
    @identity_revealed = [(@identity_key_12.to_i(16) ^ @identity_xored_key_12.to_i(16)).to_s(16)].pack('H*')
    
    
    # Generate 12-bit (3)
     
    @bit_string = ((SecureRandom.hex(2)).hex).to_s(2)
    
    if @bit_string.length < 16
      @bit_string = @bit_string.center(16, "0")
    end
    
    # Get appropriate half if 0 or 1
    
    if [@bit_string][0] == '1'
      @identity_half_01 = @identity_xored_key_01
    else
      @identity_half_01 = @identity_key_01
    end
    
    if [@bit_string][1] == '1'
      @identity_half_02 = @identity_xored_key_02
    else
      @identity_half_02 = @identity_key_02
    end
    
    if @bit_string[2] == '1'
      @identity_half_03 = @identity_xored_key_03
    else
      @identity_half_03 = @identity_key_03
    end
    
    if @bit_string[3] == '1'
      @identity_half_04 = @identity_xored_key_04
    else
      @identity_half_04 = @identity_key_04
    end
    
    if @bit_string[4] == '1'
      @identity_half_05 = @identity_xored_key_05
    else
      @identity_half_05 = @identity_key_05
    end
    
    if @bit_string[5] == '1'
      @identity_half_06 = @identity_xored_key_06
    else
      @identity_half_06 = @identity_key_06
    end
    
    if @bit_string[6] == '1'
      @identity_half_07 = @identity_xored_key_07
    else
      @identity_half_07 = @identity_key_07
    end
    
    if @bit_string[7] == '1'
      @identity_half_08 = @identity_xored_key_08
    else
      @identity_half_08 = @identity_key_08
    end
    
    if @bit_string[8] == '1'
      @identity_half_09 = @identity_xored_key_09
    else
      @identity_half_09 = @identity_key_09
    end
    
    if @bit_string[9] == '1'
      @identity_half_10 = @identity_xored_key_10
    else
      @identity_half_10 = @identity_key_10
    end
    
    if @bit_string[10] == '1'
      @identity_half_11 = @identity_xored_key_11
    else
      @identity_half_11 = @identity_key_11
    end
    
    if @bit_string[11] == '1'
      @identity_half_12 = @identity_xored_key_12
    else
      @identity_half_12 = @identity_key_12
    end
    
    if @bit_string[12] == '1'
      @identity_half_13 = @identity_xored_key_13
    else
      @identity_half_13 = @identity_key_13
    end
    
    if @bit_string[13] == '1'
      @identity_half_14 = @identity_xored_key_14
    else
      @identity_half_14 = @identity_key_14
    end
    
    if @bit_string[14] == '1'
      @identity_half_15 = @identity_xored_key_15
    else
      @identity_half_15 = @identity_key_15
    end
    
    if @bit_string[15] == '1'
      @identity_half_16 = @identity_xored_key_16
    else
      @identity_half_16 = @identity_key_16
    end
    
    
    
    render 'index'
  end
  
  def deposit
    
  end
  
end
