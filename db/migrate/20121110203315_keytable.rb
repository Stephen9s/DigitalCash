class Keytable < ActiveRecord::Migration
  def up
    create_table :keys do |t|
      
      t.string :serial
      t.integer :identity_num
      t.blob :key
      t.blob :msg_xor_key
      t.blob :signed_key
      t.blob :signed_msg_xor_key
      
    end
  end

  def down
    drop_table :keytable
  end
end

# => The key table will not be seen by the bank. The :key and :msg_xor_key will be encrypted by the bank via RSA.public_key
# => Faux table should look like:
# => 
# => SERIAL         IDENTITY_NUM        KEY             MSG_XOR_KEY
# => 123456             1            10101011101        1111111110
# => 123456             2            11111111111        1010101010   <= KEY XOR MSG XOR KEY = MSG, but I didn't do that here.
# => 
# => What I want to show is the "composite key" (SERIAL, IDENTITY_NUM) will determine which side of identity string the Merchant will receive
