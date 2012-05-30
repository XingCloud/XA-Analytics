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

ActiveRecord::Schema.define(:version => 20120530072034) do

  create_table "dimensions", :force => true do |t|
    t.integer "report_tab_id"
    t.string  "name"
    t.string  "value"
    t.string  "dimension_type"
    t.integer "level"
    t.string  "value_type",     :default => "String"
  end

  create_table "expressions", :force => true do |t|
    t.string   "name"
    t.string   "operator"
    t.string   "value"
    t.integer  "segment_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "value_type", :default => "String"
  end

  create_table "metrics", :force => true do |t|
    t.integer  "project_id"
    t.integer  "combine_id"
    t.integer  "number_of_day"
    t.string   "name"
    t.string   "event_key"
    t.string   "condition"
    t.string   "combine_action"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "number_of_day_origin"
    t.integer  "segment_id"
  end

  add_index "metrics", ["combine_id"], :name => "index_metrics_on_combine_id"

  create_table "metrics_report_tabs", :id => false, :force => true do |t|
    t.integer "report_tab_id"
    t.integer "metric_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "identifier"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "report_categories", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "report_tabs", :force => true do |t|
    t.integer  "report_id"
    t.integer  "project_id"
    t.string   "title"
    t.string   "description"
    t.string   "chart_type",  :default => "line"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "length"
    t.string   "interval"
    t.integer  "compare"
  end

  add_index "report_tabs", ["report_id"], :name => "index_report_tabs_on_report_id"

  create_table "reports", :force => true do |t|
    t.integer  "project_id"
    t.integer  "report_category_id"
    t.integer  "position"
    t.string   "title"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "reports", ["project_id"], :name => "index_reports_on_project_id"
  add_index "reports", ["report_category_id"], :name => "index_reports_on_report_category_id"

  create_table "segments", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "widget_connectors", :force => true do |t|
    t.integer "widget_id"
    t.integer "project_id"
    t.integer "display",    :default => 1
    t.integer "px"
    t.integer "py"
  end

  add_index "widget_connectors", ["project_id"], :name => "index_widget_connectors_on_project_id"
  add_index "widget_connectors", ["widget_id"], :name => "index_widget_connectors_on_widget_id"

  create_table "widgets", :force => true do |t|
    t.integer  "project_id"
    t.integer  "metric_id"
    t.integer  "report_tab_id"
    t.integer  "length",        :default => 7
    t.string   "title"
    t.string   "widget_type"
    t.string   "dimension"
    t.string   "interval",      :default => "day"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

end
