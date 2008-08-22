class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :aws_account_number
      t.string :aws_access_key
      t.string :aws_secret_access_key
      t.text :aws_x_509_key
      t.text :aws_x_509_certificate

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
