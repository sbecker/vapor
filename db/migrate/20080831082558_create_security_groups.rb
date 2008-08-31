class CreateSecurityGroups < ActiveRecord::Migration
  def self.up
    create_table :security_groups do |t|
      t.integer :account_id
      t.string :name
      t.string :description
      t.string :owner_id
      t.text :permissions

      t.timestamps
    end
  end

  def self.down
    drop_table :security_groups
  end
end
