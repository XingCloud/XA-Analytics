class AddPosyToWidgetConnectors < ActiveRecord::Migration
  def change
    remove_column :widget_connectors, :position
    add_column :widget_connectors, :px, :integer
    add_column :widget_connectors, :py, :integer
  end
end
