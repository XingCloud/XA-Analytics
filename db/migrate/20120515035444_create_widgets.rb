class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :project_id
      t.integer :metric_id
      t.integer :report_tab_id
      t.integer :length, :default => 7
      t.string :title
      t.string :widget_type
      t.string :dimension
      t.string :interval, :default => 'day'
      t.timestamps
    end
  end
end
