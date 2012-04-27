class AddDimensionToReportTab < ActiveRecord::Migration
  def change
    add_column :report_tabs, :dimension, :string
  end
end
