class CreateProjectReportCategories < ActiveRecord::Migration
  def change
    create_table :project_report_categories do |t|
      t.integer :report_category_id
      t.integer :project_id
      t.integer :position
      t.string :name
      t.boolean :display, :default => true
    end
    add_index :project_report_categories, :report_category_id
    add_index :project_report_categories, :project_id
  end
end
