# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080913233124) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "aws_account_number"
    t.string   "aws_access_key"
    t.string   "aws_secret_access_key"
    t.text     "aws_x_509_key"
    t.text     "aws_x_509_certificate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", :force => true do |t|
    t.integer  "account_id"
    t.string   "instance_id"
    t.string   "public_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "availability_zones", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "architecture"
    t.string   "aws_id"
    t.text     "description"
    t.boolean  "is_public"
    t.string   "location"
    t.string   "name"
    t.string   "owner_id"
    t.string   "state"
    t.string   "image_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "key_pairs", :force => true do |t|
    t.string   "name"
    t.string   "fingerprint"
    t.text     "private_key"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "security_groups", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "description"
    t.string   "owner_id"
    t.text     "permissions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.integer  "account_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
