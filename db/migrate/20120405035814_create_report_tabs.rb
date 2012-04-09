class CreateReportTabs < ActiveRecord::Migration
  def change
    create_table :report_tabs do |t|
      t.integer :report_id
      t.string :title
      t.string :description
      t.string :type

      t.timestamps
    end

    add_index :report_tabs, :report_id
  end
end
