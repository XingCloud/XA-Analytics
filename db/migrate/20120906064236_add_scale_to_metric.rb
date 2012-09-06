class AddScaleToMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :scale, :float, :default => 1
  end
end
