class CreateWidgetConnectors < ActiveRecord::Migration
  def change
    create_table :project_widgets, :id => false do |t|
      t.integer :widget_id
      t.integer :project_id
      t.integer :display, :default => 1
      t.integer :px
      t.integer :py
    end
    add_index :project_widgets, :widget_id
    add_index :project_widgets, :project_id
  end
end
