class DepositedCoins < ActiveRecord::Migration
  def up
    create_table :deposited_coins do |t|
      
      t.string :serial
      t.decimal :amount
      t.integer :flag, :default => 0
      
    end
  end

  def down
    drop_table :deposited_coins
  end
end
