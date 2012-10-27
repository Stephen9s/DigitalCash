class CreateUsers < ActiveRecord::Migration
  
  def change
    create_table :users do |t|
      t.string :username 
      t.string :f_name
      t.string :l_name
      t.string :email
      t.string :address
      t.string :dob
      t.integer :phone_num
      t.string :gender
      t.string :encrypted_password 
      t.string :salt
      t.timestamps
    end
  end
  
end
