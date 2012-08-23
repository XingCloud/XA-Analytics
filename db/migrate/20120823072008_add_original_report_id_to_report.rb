class AddOriginalReportIdToReport < ActiveRecord::Migration
  def change
    add_column :reports, :original_report_id, :integer
  end
end
