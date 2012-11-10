class Checking < ActiveRecord::Migration
  def up
    create_table :checking_accounts do |t|
      
      t.integer :owner_id
      t.decimal :amount # 1.50 or 2.23
      
    end
  end

  def down
    drop_table :checking_accounts
  end
end
