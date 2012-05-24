class CreateMetricReportTabJoinTable < ActiveRecord::Migration
  def change
    create_table :metrics_report_tabs, :id => false do |t|
      t.integer :report_tab_id
      t.integer :metric_id
    end
    add_index :metrics_report_tabs, :report_tab_id
    add_index :metrics_report_tabs, :metric_id
  end
end
