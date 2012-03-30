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

ActiveRecord::Schema.define(:version => 20120328075423) do

  create_table "agents", :force => true do |t|
    t.integer  "project_id"
    t.integer  "district_id"
    t.string   "identifier"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
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

  create_table "menu_reports", :id => false, :force => true do |t|
    t.integer  "menu_id"
    t.integer  "report_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "menus", :force => true do |t|
    t.string   "name",                      :null => false
    t.string   "point",      :limit => 100
    t.integer  "project_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "desc"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.boolean  "status"
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

  create_table "periods", :force => true do |t|
    t.integer  "report_id"
    t.string   "type"
    t.string   "rule"
    t.string   "rate"
    t.string   "label_number"
    t.integer  "compare_number", :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "periods", ["report_id", "type"], :name => "index_periods_on_report_id_and_type"

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
    t.integer  "template"
  end

  add_index "reports", ["project_id"], :name => "index_reports_on_project_id"
  add_index "reports", ["public"], :name => "index_reports_on_public"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_attributes", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.boolean  "admin"
    t.string   "mail"
    t.integer  "redmine_uid"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
