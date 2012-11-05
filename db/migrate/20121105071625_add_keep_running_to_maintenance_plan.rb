class AddKeepRunningToMaintenancePlan < ActiveRecord::Migration
  def change
    add_column :maintenance_plans, :keep_running, :boolean, :default => false
  end
end
