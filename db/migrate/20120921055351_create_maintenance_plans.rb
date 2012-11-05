class CreateMaintenancePlans < ActiveRecord::Migration
  def change
    create_table :maintenance_plans do |t|
      t.text :announcement
      t.datetime :begin_at
      t.datetime :end_at
      t.string :created_by
      t.timestamps
    end
  end
end
