class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.integer :project_id
      t.integer :combine_id
      t.integer :number_of_day
      t.string :name
      t.string :event_key
      t.string :condition
      t.string :combine_action
      t.string :comparison_operator
      t.string :comparison
      t.timestamps
    end

    add_index :metrics, :combine_id
  end
end
