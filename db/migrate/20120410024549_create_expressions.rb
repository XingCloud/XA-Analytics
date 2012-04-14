class CreateExpressions < ActiveRecord::Migration
  def change
    create_table :expressions do |t|
      t.string :name
      t.string :operator
      t.string :value
      t.integer :segment_id

      t.timestamps
    end
  end
end