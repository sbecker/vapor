class AddAdditionalImageColumns < ActiveRecord::Migration
  def self.up
    add_column :images, :aws_product_codes, :string
    add_column :images, :aws_kernel_id, :string
    add_column :images, :aws_ramdisk_id, :string
  end

  def self.down
    remove_column :images, :aws_ramdisk_id
    remove_column :images, :aws_kernel_id
    remove_column :images, :aws_product_codes
  end
end
