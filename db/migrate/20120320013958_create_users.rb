class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.boolean :admin
      t.string :mail
      t.integer :redmine_uid

      t.timestamps
    end
  end
end
