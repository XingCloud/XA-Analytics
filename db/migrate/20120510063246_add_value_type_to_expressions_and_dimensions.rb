class AddValueTypeToExpressionsAndDimensions < ActiveRecord::Migration
  def change
    add_column :expressions, :value_type, :string, :default => 'String'
    add_column :dimensions, :value_type, :string, :default => 'String'
  end
end
