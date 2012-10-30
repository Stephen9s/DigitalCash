class ExamplesController < ApplicationController
  
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
      @binary_0 = (params[:xor][:binary0].to_i).to_s(2)
      @binary_1 = (params[:xor][:binary1].to_i).to_s(2)
      @binary_result = (@binary_0.to_i(base=2) ^ @binary_1.to_i(base=2)).to_s(2)
    else
      @binary_result = "Error"
    end
  end
end
