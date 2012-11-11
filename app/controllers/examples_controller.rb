class ExamplesController < ApplicationController
  
  require 'base64'
  
  def index
    
  end
  
  def aes
    if params[:aes]
      @key = Gibberish::AES.new(params[:aes][:pass])
      @key_plaintext = params[:aes][:pass]
      @enc_msg = @key.enc(params[:aes][:msg])
      @dec_msg = @key.dec(@enc_msg)
      flash[:notice] = "Success!"
    else
      flash[:notice] = "No password or message present."
    end
  end
  
  def rsa
    if params[:rsa]
      k = Gibberish::RSA.generate_keypair(1024)
      @pub_key = k.public_key
      @pri_key = k.private_key
      cipher = Gibberish::RSA.new(k.public_key)
      @enc = cipher.encrypt(params[:rsa][:msg])
      
      cipher_a = Gibberish::RSA.new(k.private_key)
      @dec = cipher_a.decrypt(@enc)
    end
  end
  
  def xor
    if params[:xor]
      
      # BEFORE MOVING ON
      # YOU CAN REMOVE to_s(2) IF you convert the hex to decimal via 'string'.hex <-- converts to decimal; however, the raise will check the string for hex-only characters
      # IF you want to XOR decimal, then remove (base=2) because to_i(base=2) says to convert the BINARY data stream INTO decimal
      
      # check input 0 and input 1 for HEX only
      raise "Not a valid hex string" unless(params[:xor][:binary0] =~ /^[\da-fA-F]+$/)
      raise "Not a valid hex string" unless(params[:xor][:binary1] =~ /^[\da-fA-F]+$/)
      
      @binary_0 = (params[:xor][:binary0].hex).to_s(2)
      @binary_1 = (params[:xor][:binary1].hex).to_s(2)
      @binary_result = (@binary_0.to_i(base=2) ^ @binary_1.to_i(base=2)).to_s(2)
      @hex_result = (@binary_result.to_i(base=2)).to_s(16)
      @base64_result = Base64.encode64(@hex_result)
      @decode64_result = Base64.decode64(@base64_result)
      @decode64_result_to_binary = (@decode64_result.hex).to_s(2)
      @binary_xor_show_msg1 =  (@decode64_result_to_binary.to_i(base=2) ^ @binary_1.to_i(base=2)).to_s(2) #reveal message 1 by XORing out message 2
      @binary_xor_show_msg2 =  (@decode64_result_to_binary.to_i(base=2) ^ @binary_0.to_i(base=2)).to_s(2) #reveal message 1 by XORing out message 2
      
      #@binary_result = i.to_s(16)   # decimal to hex (store hex in database)
      #decimal = s.hex  # hex into decimal
      #binary = (s.hex).to_s(2) # decimal to binary
      
      #@binary_result = binary #decimal #(binary.to_i(base=2))
      
      k = Gibberish::RSA.generate_keypair(1024)
      @pub_key = k.public_key
      @pri_key = k.private_key
      
      cipher = Gibberish::RSA.new(@pub_key)
      @enc = cipher.encrypt(@hex_result)
      @key_enc = cipher.encrypt((@binary_1.to_i(base=2)).to_s(16))
      
      cipher_a = Gibberish::RSA.new(@pri_key)
      @dec = cipher_a.decrypt(@enc)
      
      @msg_xor_dec = cipher_a.decrypt(@key_enc)
      
      # now we have @dec and @msg_xor_dec
      # should equal @binary_0
      @rsa_enc_hex_xor_to_binary = (@dec.hex).to_s(2)
      @rsa_enc_message2_to_binary = (@msg_xor_dec.hex).to_s(2)
      @decrypted_xor_binary = (@rsa_enc_hex_xor_to_binary.to_i(base=2) ^ @rsa_enc_message2_to_binary.to_i(base=2)).to_s(2)
      @decrypted_xor = (@decrypted_xor_binary.to_i(base=2)).to_s(16)
      
      @rsa_hex = @pri_key.unpack('H*').first
      @rsa_original = [@rsa_hex].pack('H*')
    else
      @binary_result = "Error"
    end
  end
end
