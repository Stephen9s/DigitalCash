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

# The purse will be where all coins exist, spent or not.
# Owner_id gives away information; it is possible to use :recipient_id as a way of determining WHO currently has that coin.
# => :recipient_id will be 0 if :owner_id hasn't given it out yet.
# => Assume we get a new coin signed by the virtual bank
# =>    We're going to have an :owner_id = 1 and :recipient_id = 0
# =>    This implies (1) has not spent that coin, so she can see it in his/her purse.
# =>    If we send the coin to :owner_id = 2, then :recipient_id will change to 2.
# =>    The online purse will check for the current_user's login session, find all coins with that owner_id, and only show coins with recipient_id = 0.
# =>        for those looking at their Received Coins, the SQL looks for recipient_id = current_user.id.
