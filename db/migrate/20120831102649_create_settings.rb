class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :project_id
      t.string :event_level
      t.timestamps
    end
  end
end
