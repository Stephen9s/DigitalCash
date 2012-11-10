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
