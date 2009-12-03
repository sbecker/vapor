class AddRegionNameToAvailabilityZones < ActiveRecord::Migration
  def self.up
    add_column :availability_zones, :region_name, :string
  end

  def self.down
    remove_column :availability_zones, :region_name
  end
end
