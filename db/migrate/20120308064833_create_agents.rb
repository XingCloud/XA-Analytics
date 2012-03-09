class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.integer :project_id
      t.integer :district_id
      t.string :identifier
      
      t.timestamps
    end
  end
end
