class CreateVolumes < ActiveRecord::Migration
  def self.up
    create_table :volumes do |t|
      t.integer :account_id
      t.datetime :aws_attached_at
      t.string :aws_attachment_status
      t.datetime :aws_created_at
      t.string :aws_device
      t.string :aws_id
      t.string :aws_instance_id
      t.integer :aws_size
      t.string :aws_status
      t.string :snapshot_id
      t.string :zone

      t.timestamps
    end
  end

  def self.down
    drop_table :volumes
  end
end
