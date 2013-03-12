class AddVisitToProjectUsers < ActiveRecord::Migration
  def change
    add_column :project_users, :visit, :integer, :default => 0
  end
end
