class CreateReportTabMetricJoinTable < ActiveRecord::Migration
  def up
    create_table :report_tabs_metrics, :id => false do |t|
      t.integer :report_tab_id
      t.integer :metric_id
    end
  end

  def down
    drop_table :report_tabs_metrics
  end
end
