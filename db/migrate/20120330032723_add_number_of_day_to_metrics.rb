class AddNumberOfDayToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :number_of_day, :integer
  end
end