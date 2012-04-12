class CreateReportCategories < ActiveRecord::Migration
  def change
    create_table :report_categories do |t|
      t.string :name
      t.integer :position
      t.integer :project_id

      t.timestamps
    end
  end
end
