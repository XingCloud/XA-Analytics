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

ActiveRecord::Schema.define(:version => 20120313035213) do

  create_table "agents", :force => true do |t|
    t.integer  "project_id"
    t.integer  "district_id"
    t.string   "identifier"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "cycles", :force => true do |t|
    t.integer  "report_id"
    t.string   "rate"
    t.integer  "period"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_users", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "menus", :force => true do |t|
    t.string   "name",                      :null => false
    t.string   "point",      :limit => 100
    t.integer  "project_id",                :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "desc"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "menus", ["parent_id"], :name => "index_menus_on_parent_id"
  add_index "menus", ["project_id"], :name => "index_menus_on_project_id"

  create_table "metrics", :force => true do |t|
    t.integer  "report_id"
    t.string   "event_key"
    t.string   "condition"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "combine_id"
    t.string   "combine_action"
    t.string   "comparison_operator"
    t.string   "comparison"
    t.string   "name"
    t.integer  "project_id"
  end

  add_index "metrics", ["combine_id"], :name => "index_metrics_on_combine_id"

  create_table "platforms", :force => true do |t|
    t.string   "name"
    t.string   "identifier"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "identifier"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reports", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "purpose"
    t.string   "type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "project_id"
    t.boolean  "public",      :default => false
  end

  add_index "reports", ["project_id"], :name => "index_reports_on_project_id"
  add_index "reports", ["public"], :name => "index_reports_on_public"

  create_table "user_attributes", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
