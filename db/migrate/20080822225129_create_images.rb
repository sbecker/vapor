class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :architecture
      t.string :aws_id
      t.text :description
      t.boolean :is_public
      t.string :location
      t.string :name
      t.string :owner_id
      t.string :state
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
