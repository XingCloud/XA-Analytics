class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.integer :project_id
      t.string :date
      t.string :channel
      t.string :fee

      t.timestamps
    end
  end
end
