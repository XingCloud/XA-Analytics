class CreateActionLogs < ActiveRecord::Migration
  def change
    create_table :action_logs do |t|
      t.integer :project_id
      t.string :resource_type
      t.string :resource_name
      t.string :action
      t.string :user
      t.datetime :perform_at
    end
  end
end
