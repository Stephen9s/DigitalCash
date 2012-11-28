# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121113003712) do

  create_table "checking_accounts", :force => true do |t|
    t.integer "owner_id"
    t.decimal "amount"
  end

  create_table "deposited_coins", :force => true do |t|
    t.string  "serial"
    t.decimal "amount"
    t.integer "flag",   :default => 0
  end

  create_table "deposited_coins_keys", :force => true do |t|
    t.string  "serial"
    t.integer "identity_num"
    t.string  "identity_half"
  end

  create_table "keys", :force => true do |t|
    t.string  "serial"
    t.integer "identity_num"
    t.blob  "key"
    t.blob  "msg_xor_key"
    t.blob  "signed_key"
    t.blob  "signed_msg_xor_key"
  end

  create_table "purses", :force => true do |t|
    t.integer "owner_id"
    t.integer "recipient_id"
    t.string  "serial"
    t.integer "denomination"
  end

  create_table "rsa_keys", :force => true do |t|
    t.blob "modulus"
    t.blob "encryption"
    t.blob "decryption"
  end

  create_table "temp_transactions", :force => true do |t|
    t.string  "serial"
    t.integer "identity_num"
    t.blob  "identity_half"
    t.blob    "signed_half"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "f_name"
    t.string   "l_name"
    t.string   "email"
    t.string   "address"
    t.string   "dob"
    t.integer  "phone_num"
    t.string   "gender"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
