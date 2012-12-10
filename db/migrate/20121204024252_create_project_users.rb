class CreateProjectUsers < ActiveRecord::Migration
  def change
    create_table :project_users do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :role
      t.text :privilege
    end

    add_index :project_users, :project_id
    add_index :project_users, :user_id
  end
end
