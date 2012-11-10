class Purses < ActiveRecord::Migration
  def up
    create_table :purses do |t|
      
      t.integer :owner_id
      t.integer :recipient_id
      t.string :serial
      t.integer :denomination
      
    end
  end

  def down
    drop_table :purses
  end
end
