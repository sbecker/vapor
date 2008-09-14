class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer :account_id
      t.string :instance_id
      t.string :public_ip

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
