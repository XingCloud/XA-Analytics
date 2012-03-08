class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :project_id
      t.string :name
      
      t.timestamps
    end
  end
end
