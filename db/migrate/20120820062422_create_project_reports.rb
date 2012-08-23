class CreateProjectReports < ActiveRecord::Migration
  def change
    create_table :project_reports do |t|
      t.integer :project_id
      t.integer :report_id
      t.integer :report_category_id
      t.boolean :display, :default => true
    end
    add_index :project_reports, :project_id
    add_index :project_reports, :report_id
  end
end
