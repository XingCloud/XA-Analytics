class CreateRoleUsers < ActiveRecord::Migration
  def change
    create_table :user_roles,:id => false do |t|
      t.integer :role_id
      t.integer :user_id

      t.timestamps
    end
  end
end
