class CreateBroadcastings < ActiveRecord::Migration
  def change
    create_table :broadcastings do |t|
      t.string :message

      t.timestamps
    end
  end
end
