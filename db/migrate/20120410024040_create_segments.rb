class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :name
      t.integer :project_id
      t.integer :status ,:default => 0,:limit => 1

      t.timestamps
    end
  end
end
