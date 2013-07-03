class AddTimeTypeToExpression < ActiveRecord::Migration
  def change
    add_column :expressions, :time_type, :string
  end
end
