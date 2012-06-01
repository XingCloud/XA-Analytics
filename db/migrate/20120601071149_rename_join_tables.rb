class RenameJoinTables < ActiveRecord::Migration
  def change
    rename_table :widget_connectors, :project_widgets
    rename_table :metrics_report_tabs, :report_tab_metrics
    add_column :report_tab_metrics, :id, :primary_key
    add_column :report_tab_metrics, :position, :integer, :default => 0
  end
end
