class RenameColumnsToMatchRightAws < ActiveRecord::Migration
  def self.up
    rename_column :availability_zones, :name,             :zone_name
    rename_column :availability_zones, :state,            :zone_state

    rename_column :images,             :architecture,     :aws_architecture
    rename_column :images,             :is_public,        :aws_is_public
    rename_column :images,             :location,         :aws_location
    rename_column :images,             :owner_id,         :aws_owner
    rename_column :images,             :state,            :aws_state
    rename_column :images,             :image_type,       :aws_image_type

    rename_column :key_pairs,          :name,             :aws_key_name
    rename_column :key_pairs,          :fingerprint,      :aws_fingerprint
    rename_column :key_pairs,          :private_key,      :aws_material

    rename_column :security_groups,    :name,             :aws_group_name
    rename_column :security_groups,    :description,      :aws_description
    rename_column :security_groups,    :owner_id,         :aws_owner
    rename_column :security_groups,    :permissions,      :aws_perms
  end

  def self.down
    rename_column :security_groups,    :aws_perms,        :permissions
    rename_column :security_groups,    :aws_owner,        :owner_id
    rename_column :security_groups,    :aws_description,  :description
    rename_column :security_groups,    :aws_group_name,   :name

    rename_column :key_pairs,          :aws_material,     :private_key
    rename_column :key_pairs,          :aws_fingerprint,  :fingerprint
    rename_column :key_pairs,          :aws_key_name,     :name

    rename_column :images,             :aws_image_type,   :image_type
    rename_column :images,             :aws_state,        :state
    rename_column :images,             :aws_owner,        :owner_id
    rename_column :images,             :aws_location,     :location
    rename_column :images,             :aws_is_public,    :is_public
    rename_column :images,             :aws_architecture, :architecture

    rename_column :availability_zones, :zone_state,       :state
    rename_column :availability_zones, :zone_name,        :name
  end
end
