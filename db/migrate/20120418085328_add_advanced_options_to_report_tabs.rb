class AddAdvancedOptionsToReportTabs < ActiveRecord::Migration
  def change
    add_column :report_tabs, :length, :integer, :default => 7
    add_column :report_tabs, :interval, :string, :default => "day"
    add_column :report_tabs, :compare, :integer, :default => 0
  end
end
