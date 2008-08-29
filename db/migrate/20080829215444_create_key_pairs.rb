class CreateKeyPairs < ActiveRecord::Migration
  def self.up
    create_table :key_pairs do |t|
      t.string :name
      t.string :fingerprint
      t.text :private_key
      t.integer :account_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :key_pairs
  end
end
