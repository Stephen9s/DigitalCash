class DepositedCoinsKeys < ActiveRecord::Migration
  def up
    create_table :deposited_coins_keys do |t|
      
      t.string :serial
      t.integer :identity_num
      t.string :identity_half # will be the concurrent half; if Deposited Coin is flagged, then this half should have been XORed and contain someone's identity
      
    end
  end

  def down
    drop_table :deposited_coins_keys
  end
end

# => The deposited coins keys table is is a copy of the temptransaction table, but this contains processed data after the bank removes the RSA encryption.
# => After the bank adds the coin's serial number and amount into the :deposited_coins table, and if there is no conflict, Bob's checking account will be updated.
# => If there IS a conflict, then the bank will check this table to see what it has stored about the coin.
# => ALL coins will have SOME information deposited into this table.

# => It may be best to leave the coins RSA encrypted when in this table. The idea is, if there IS a conflict, the bank can decrypt the coin, decrypt the deposited_coin, XOR them, then re-encrypt them.
# => After this XOR or XOR/re-encryption, the bank will overwrite the deposited coin then flag the coin in :deposited_coins.

# => The flag is a boolean integer value to determine if the coin's cheater has been identified.
# => That is, if Alice uses it for a third time, they won't need to re-calculate anything. They can just send Alice to jail :).