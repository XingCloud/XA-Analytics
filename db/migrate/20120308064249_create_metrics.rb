class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.integer :project_id
      t.integer :combine_id
      t.integer :segment_id
      t.integer :number_of_day
      t.integer :number_of_day_origin
      t.string :name
      t.string :event_key
      t.string :condition
      t.string :combine_action
      t.text :description
      t.timestamps
    end

    add_index :metrics, :combine_id
  end
end
