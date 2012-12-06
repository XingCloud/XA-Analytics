class AddValueTypeToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :value_type, :string, :default => "origin"
  end
end
