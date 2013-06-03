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

ActiveRecord::Schema.define(version: 20130603141503) do

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
    t.integer  "team_id",                null: false
  end

  add_index "accounts", ["activation_token"], name: "index_accounts_on_activation_token", unique: true, using: :btree
  add_index "accounts", ["auth_token"], name: "index_accounts_on_auth_token", unique: true, using: :btree
  add_index "accounts", ["password_reset_token"], name: "index_accounts_on_password_reset_token", unique: true, using: :btree
  add_index "accounts", ["team_id"], name: "index_accounts_on_team_id", using: :btree

  create_table "sprints", force: true do |t|
    t.integer  "projected_velocity",                   null: false
    t.integer  "measured_velocity"
    t.string   "status",             default: "draft", null: false
    t.date     "start_on"
    t.date     "end_on"
    t.integer  "team_id",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sprints", ["team_id"], name: "index_sprints_on_team_id", using: :btree

  create_table "stories", force: true do |t|
    t.text     "description",        default: "As a role\nI can do something\nso I get a benefit", null: false
    t.integer  "points",             default: 3,                                                   null: false
    t.integer  "row_order",                                                                        null: false
    t.integer  "tech_lead_id"
    t.integer  "product_manager_id"
    t.string   "business_driver"
    t.string   "spec_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id",                                                                          null: false
  end

  add_index "stories", ["product_manager_id"], name: "index_stories_on_product_manager_id", using: :btree
  add_index "stories", ["team_id"], name: "index_stories_on_team_id", using: :btree
  add_index "stories", ["tech_lead_id"], name: "index_stories_on_tech_lead_id", using: :btree

  create_table "taskable_stories", force: true do |t|
    t.string   "status",     default: "draft", null: false
    t.integer  "row_order",                    null: false
    t.integer  "story_id",                     null: false
    t.integer  "sprint_id",                    null: false
    t.integer  "team_id",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taskable_stories", ["sprint_id"], name: "index_taskable_stories_on_sprint_id", using: :btree
  add_index "taskable_stories", ["story_id"], name: "index_taskable_stories_on_story_id", using: :btree
  add_index "taskable_stories", ["team_id"], name: "index_taskable_stories_on_team_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "description",       null: false
    t.string   "hours",             null: false
    t.string   "status",            null: false
    t.integer  "row_order",         null: false
    t.integer  "taskable_story_id", null: false
    t.integer  "team_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["taskable_story_id"], name: "index_tasks_on_taskable_story_id", using: :btree
  add_index "tasks", ["team_id"], name: "index_tasks_on_team_id", using: :btree

  create_table "teammates", force: true do |t|
    t.string   "name",                    null: false
    t.string   "roles",      default: [],              array: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id",                 null: false
    t.string   "color",                   null: false
    t.string   "initials",                null: false
  end

  add_index "teammates", ["account_id"], name: "index_teammates_on_account_id", using: :btree
  add_index "teammates", ["name"], name: "index_teammates_on_name", unique: true, using: :btree
  add_index "teammates", ["roles"], name: "teammates_roles", using: :gin
  add_index "teammates", ["team_id"], name: "index_teammates_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "projected_velocity", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
