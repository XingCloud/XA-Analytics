class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions ,:id => false do |t|
      t.integer :role_id
      t.integer :menu_id

      t.timestamps
    end
  end
end
