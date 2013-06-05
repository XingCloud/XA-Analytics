class AddScaleStartdateToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :scale_startdate, :string
  end
end
