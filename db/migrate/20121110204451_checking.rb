class Checking < ActiveRecord::Migration
  def up
    create_table :checking_accounts do |t|
      
      t.integer :owner_id
      t.integer :amount
      
    end
  end

  def down
    drop_table :checking_accounts
  end
end

# => Holds the person's money.