class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.integer :report_id
      t.string :rate
      t.integer :period
      
      t.timestamps
    end
  end
end
