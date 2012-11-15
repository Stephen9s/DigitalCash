class RsaKeys < ActiveRecord::Migration
  def up
    create_table :rsa_keys do |t|
      t.blob :private_key
      t.blob :public_key
    end
  end

  def down
    drop_table :rsa_keys
  end
end
