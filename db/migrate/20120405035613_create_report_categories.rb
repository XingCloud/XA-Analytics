class CreateReportCategories < ActiveRecord::Migration
  def change
    create_table :report_categories do |t|
      t.string :name
      t.integer :template
      t.integer :position

      t.timestamps
    end
  end
end
