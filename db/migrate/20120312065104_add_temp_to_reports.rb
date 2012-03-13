class AddTempToReports < ActiveRecord::Migration
  def change
    add_column :reports, :public, :boolean, :default => false
    add_index :reports, :public
  end
end
