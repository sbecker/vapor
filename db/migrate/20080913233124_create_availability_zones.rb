class CreateAvailabilityZones < ActiveRecord::Migration
  def self.up
    create_table :availability_zones do |t|
      t.integer :account_id
      t.string :name
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :availability_zones
  end
end
