class Keytable < ActiveRecord::Migration
  def up
    create_table :keytable do |t|
      
      t.string :serial
      t.integer :identity_num
      t.string :key
      t.string :msg_xor_key
      
    end
  end

  def down
    drop_table :keytable
  end
end
