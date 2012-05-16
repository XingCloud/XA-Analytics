class AddNumberOfDayOriginToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :number_of_day_origin, :integer
  end
end
