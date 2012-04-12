class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :project_id
      t.integer :report_category_id
      t.integer :position
      t.string :title

      t.timestamps
    end

    add_index :reports, :project_id
    add_index :reports, :report_category_id
  end
end
