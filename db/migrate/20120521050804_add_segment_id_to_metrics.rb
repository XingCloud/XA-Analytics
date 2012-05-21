class AddSegmentIdToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :segment_id, :integer
    remove_column :metrics, :comparison
    remove_column :metrics, :comparison_operator
  end
end
