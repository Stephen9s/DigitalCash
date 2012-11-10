class Tempkeytable < ActiveRecord::Migration
  def up
    create_table :temptransaction do |t|
      
      t.string :serial
      t.integer :identity_num
      t.string :identity_half # the half that the merchant requests (at random)
      
    end
  end

  def down
    drop_table :temptransaction
  end
end
