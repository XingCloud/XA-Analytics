class CreateWidgetConnectors < ActiveRecord::Migration
  def change
    create_table :widget_connectors do |t|
      t.integer :widget_id
      t.integer :project_id
      t.integer :display, :default => 1
      t.integer :position, :default => 0
    end
    add_index :widget_connectors, :widget_id
    add_index :widget_connectors, :project_id
  end
end
