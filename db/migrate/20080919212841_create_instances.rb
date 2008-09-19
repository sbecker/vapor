class CreateInstances < ActiveRecord::Migration
  def self.up
    create_table :instances do |t|
      t.integer :account_id
      t.integer :ami_launch_index
      t.string :aws_availability_zone
      t.string :aws_groups
      t.string :aws_image_id
      t.string :aws_instance_id
      t.string :aws_instance_type
      t.string :aws_kernel_id
      t.datetime :aws_launch_time
      t.string :aws_owner
      t.string :aws_product_codes
      t.string :aws_ramdisk_id
      t.string :aws_reason
      t.string :aws_reservation_id
      t.string :aws_state
      t.string :aws_state_code
      t.string :dns_name
      t.string :private_dns_name
      t.string :ssh_key_name

      t.timestamps
    end
  end

  def self.down
    drop_table :instances
  end
end
