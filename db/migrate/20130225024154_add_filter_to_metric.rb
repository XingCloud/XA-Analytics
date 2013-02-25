class AddFilterToMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :filter_operator, :string
    add_column :metrics, :filter_value, :string
  end
end
