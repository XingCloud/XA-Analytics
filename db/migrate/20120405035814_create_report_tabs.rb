class CreateReportTabs < ActiveRecord::Migration
  def change
    create_table :report_tabs do |t|
      t.integer :report_id
      t.integer :project_id
      t.string :title
      t.string :description
      t.string :chart_type, :default => "line"

      t.integer :length, :default => 7
      t.string :interval, :default => "day"
      t.integer :compare, :default => 0
    end

    add_index :report_tabs, :report_id
  end
end
