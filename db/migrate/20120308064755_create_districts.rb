class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name
      t.string :identifier
      
      t.timestamps
    end
  end
end
