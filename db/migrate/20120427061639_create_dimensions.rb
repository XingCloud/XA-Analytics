class CreateDimensions < ActiveRecord::Migration
  def change
    create_table :dimensions do |t|
      t.integer :report_tab_id
      t.string :name
      t.string :value
      t.string :value_tupe, :default => 'String'
      t.string :dimension_type
      t.integer :level
    end
  end
end
