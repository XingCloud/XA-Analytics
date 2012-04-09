class RemoveReportIdFromMetric < ActiveRecord::Migration
  def up
    remove_column :metrics, :report_id
  end

  def down
  end
end
