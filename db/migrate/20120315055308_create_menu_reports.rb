class CreateMenuReports < ActiveRecord::Migration
  def change
    create_table :menu_reports ,:id=>false do |t|
      t.integer :menu_id
      t.integer :report_id

      t.timestamps
    end
  end
end
