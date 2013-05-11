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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130511181002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "activation_token"
    t.datetime "activated_at"
  end

  add_index "accounts", ["activation_token"], name: "index_accounts_on_activation_token", unique: true, using: :btree
  add_index "accounts", ["auth_token"], name: "index_accounts_on_auth_token", unique: true, using: :btree
  add_index "accounts", ["password_reset_token"], name: "index_accounts_on_password_reset_token", unique: true, using: :btree

  create_table "stories", force: true do |t|
    t.string   "description",        null: false
    t.integer  "points",             null: false
    t.integer  "row_order",          null: false
    t.integer  "tech_lead_id"
    t.integer  "product_manager_id"
    t.string   "business_driver"
    t.string   "spec_link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stories", ["product_manager_id"], name: "index_stories_on_product_manager_id", using: :btree
  add_index "stories", ["tech_lead_id"], name: "index_stories_on_tech_lead_id", using: :btree

  create_table "teammates", force: true do |t|
    t.string   "name",       null: false
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teammates", ["account_id"], name: "index_teammates_on_account_id", using: :btree

end
