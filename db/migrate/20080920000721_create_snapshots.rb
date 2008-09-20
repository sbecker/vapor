class CreateSnapshots < ActiveRecord::Migration
  def self.up
    create_table :snapshots do |t|
      t.integer :account_id
      t.string :aws_id
      t.string :aws_progress
      t.datetime :aws_started_at
      t.string :aws_status
      t.string :aws_volume_id

      t.timestamps
    end
  end

  def self.down
    drop_table :snapshots
  end
end
