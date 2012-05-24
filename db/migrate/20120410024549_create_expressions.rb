class CreateExpressions < ActiveRecord::Migration
  def change
    create_table :expressions do |t|
      t.string :name
      t.string :operator
      t.string :value
      t.string :value_type, :default => 'String'
      t.integer :segment_id

      t.timestamps
    end
  end
end