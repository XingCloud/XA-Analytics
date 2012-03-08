class CreateUserAttributes < ActiveRecord::Migration
  def change
    create_table :user_attributes do |t|
      t.string :name
      t.string :key
      t.string :type
      
      t.timestamps
    end
  end
end
