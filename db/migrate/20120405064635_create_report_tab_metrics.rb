class CreateMetricReportTabJoinTable < ActiveRecord::Migration
  def change
    create_table :report_tab_metrics do |t|
      t.integer :report_tab_id
      t.integer :metric_id
      t.integer :position, :default => 0
    end
    add_index :report_tab_metrics, :report_tab_id
    add_index :report_tab_metrics, :metric_id
  end
end
