class AddNameToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :name, :string
  end
end
