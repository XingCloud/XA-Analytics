class AddStatusToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :status, :boolean
    change_column :menus, :project_id, :integer, :null => true
  end
end
