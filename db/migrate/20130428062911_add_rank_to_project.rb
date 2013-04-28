class AddRankToProject < ActiveRecord::Migration
  def change
    add_column :projects, :rank, :integer
    remove_column :project_users, :visit
  end
end
