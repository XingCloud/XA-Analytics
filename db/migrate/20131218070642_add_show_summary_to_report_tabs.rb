class AddShowSummaryToReportTabs < ActiveRecord::Migration
  def change
    add_column :report_tabs, :show_summary, :boolean, :default => 1
  end
end
