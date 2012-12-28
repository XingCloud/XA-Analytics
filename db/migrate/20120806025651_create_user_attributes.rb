class CreateUserAttributes < ActiveRecord::Migration
  def change
    create_table :user_attributes do |t|
      t.string :name
      t.string :nickname
      t.string :atype
      t.string :gpattern
      t.integer :project_id
      t.timestamps
    end
  end
end
