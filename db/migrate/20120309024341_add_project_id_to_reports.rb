class AddProjectIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :project_id, :integer
    add_index :reports, :project_id
  end
end
