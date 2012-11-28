class Tempkeytable < ActiveRecord::Migration
  def up
    create_table :temptransactions do |t|
      
      t.string :serial
      t.integer :identity_num
      t.blob :identity_half # the half that the merchant requests (at random)
      t.blob :signed_half
      
    end
  end

  def down
    drop_table :temptransactions
  end
end

# => The temporary key table contains a temporary transaction object. It will be deleted after the merchant it sends it to the bank.
# => Assume that Alice sends Bob a coin, and the coin sits in Bob's purse. Bob can cash it at a later time.
# => Bob will need to generate an n-bit string that Alice will honor and give each corresponding half to Bob. This is the table.
# => Basically, this table is exactly like the keytable, but only stores one half, and that half is STILL RSA encrypted, so Bob doesn't know ANYTHING.

# => SERIAL         IDENTITY_NUM        HALF        
# => 123456             1            11111111110
# => 123456             2            11111111111         <= KEY XOR MSG XOR KEY = MSG, but I didn't do that here.