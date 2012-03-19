class CreateRoleUsers < ActiveRecord::Migration
  def change
    create_table :role_users,:id => false do |t|
      t.integer :role_id
      t.integer :user_id

      t.timestamps
    end
  end
end
