class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string  :name ,:null => false
      t.string  :point,:limit  => 100
      t.integer :project_id,:null => false
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.string :desc
      
      t.timestamps
    end
    add_index :menus, :parent_id
    add_index :menus, :project_id
  end
end