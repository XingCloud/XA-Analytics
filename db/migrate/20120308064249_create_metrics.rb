class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.integer :report_id
      t.string :event_key
      t.string :condition
      
      t.timestamps
    end
  end
end
