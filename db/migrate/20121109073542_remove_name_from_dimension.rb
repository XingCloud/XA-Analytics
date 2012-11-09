class RemoveNameFromDimension < ActiveRecord::Migration
  def change
    remove_column :dimensions, :name
  end
end
