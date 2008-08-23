class AddAccountIdToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :account_id, :integer
  end

  def self.down
    remove_column :images, :account_id
  end
end
