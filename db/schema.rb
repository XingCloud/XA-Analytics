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

ActiveRecord::Schema.define(:version => 20130225024154) do

  create_table "action_logs", :force => true do |t|
    t.integer  "project_id"
    t.string   "resource_type"
    t.string   "resource_name"
    t.string   "action"
    t.string   "user"
    t.datetime "perform_at"
  end

  create_table "broadcastings", :force => true do |t|
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "dimensions", :force => true do |t|
    t.integer "report_tab_id"
    t.string  "value"
    t.string  "dimension_type"
    t.integer "level"
    t.string  "value_type",     :default => "String"
  end

  create_table "expressions", :force => true do |t|
    t.string   "name"
    t.string   "operator"
    t.text     "value"
    t.integer  "segment_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "value_type", :default => "String"
  end

  create_table "maintenance_plans", :force => true do |t|
    t.text     "announcement"
    t.datetime "begin_at"
    t.datetime "end_at"
    t.string   "created_by"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "keep_running", :default => false
  end

  create_table "metrics", :force => true do |t|
    t.string   "event_key"
    t.string   "condition"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "combine_id"
    t.string   "combine_action"
    t.string   "name"
    t.integer  "project_id"
    t.integer  "number_of_day"
    t.integer  "number_of_day_origin"
    t.integer  "segment_id"
    t.text     "description"
    t.float    "scale",                :default => 1.0
    t.string   "value_type",           :default => "origin"
    t.string   "filter_operator"
    t.string   "filter_value"
  end

  add_index "metrics", ["combine_id"], :name => "index_metrics_on_combine_id"

  create_table "project_report_categories", :force => true do |t|
    t.integer "report_category_id"
    t.integer "project_id"
    t.integer "position"
    t.string  "name"
    t.boolean "display",            :default => true
  end

  add_index "project_report_categories", ["project_id"], :name => "index_project_report_categories_on_project_id"
  add_index "project_report_categories", ["report_category_id"], :name => "index_project_report_categories_on_report_category_id"

  create_table "project_reports", :force => true do |t|
    t.integer "project_id"
    t.integer "report_id"
    t.integer "report_category_id"
    t.boolean "display",            :default => true
  end

  add_index "project_reports", ["project_id"], :name => "index_project_reports_on_project_id"
  add_index "project_reports", ["report_id"], :name => "index_project_reports_on_report_id"

  create_table "project_users", :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.string  "role"
    t.text    "privilege"
  end

  add_index "project_users", ["project_id"], :name => "index_project_users_on_project_id"
  add_index "project_users", ["user_id"], :name => "index_project_users_on_user_id"

  create_table "project_widgets", :force => true do |t|
    t.integer "widget_id"
    t.integer "project_id"
    t.integer "display",    :default => 1
    t.integer "px"
    t.integer "py"
  end

  add_index "project_widgets", ["project_id"], :name => "index_widget_connectors_on_project_id"
  add_index "project_widgets", ["widget_id"], :name => "index_widget_connectors_on_widget_id"

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

  create_table "report_tab_metrics", :force => true do |t|
    t.integer "report_tab_id"
    t.integer "metric_id"
    t.integer "position",      :default => 0
  end

  create_table "report_tabs", :force => true do |t|
    t.integer  "report_id"
    t.integer  "project_id"
    t.string   "title"
    t.string   "description"
    t.string   "chart_type",  :default => "line"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "length",      :default => 7
    t.string   "interval",    :default => "day"
    t.integer  "compare",     :default => 0
    t.boolean  "show_table",  :default => false
    t.integer  "day_offset",  :default => 0
  end

  add_index "report_tabs", ["report_id"], :name => "index_report_tabs_on_report_id"

  create_table "reports", :force => true do |t|
    t.integer  "project_id"
    t.integer  "report_category_id"
    t.integer  "position"
    t.string   "title"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "original_report_id"
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

  create_table "settings", :force => true do |t|
    t.integer  "project_id"
    t.string   "event_level"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "translations", :force => true do |t|
    t.integer  "rid"
    t.string   "rtype"
    t.string   "rfield"
    t.string   "locale"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_attributes", :force => true do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "atype"
    t.string   "gpattern"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_preferences", :force => true do |t|
    t.string   "user"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_preferences", ["user"], :name => "index_user_preferences_on_user"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

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
