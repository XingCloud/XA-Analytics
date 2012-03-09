class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :title
      t.string :description
      t.string :purpose
      t.string :type
      
      t.timestamps
    end
  end
end
