class AddCombineToMertics < ActiveRecord::Migration
  def change
    add_column :metrics, :combine_id, :integer
    add_column :metrics, :combine_action, :string
    add_index :metrics, :combine_id
    
    add_column :metrics, :comparison_operator, :string
    add_column :metrics, :comparison, :string
  end
end
