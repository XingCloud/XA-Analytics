class AddProjectIdToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :project_id, :integer
  end
end
