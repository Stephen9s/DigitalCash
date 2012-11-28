class RsaKeys < ActiveRecord::Migration
  def up
    create_table :rsa_keys do |t|
      t.blob :modulus
      t.blob :encryption
      t.blob :decryption
    end
  end

  def down
    drop_table :rsa_keys
  end
end
