class ChangeValueInExpression < ActiveRecord::Migration
  def change
    change_column :expressions, :value, :text
  end
end
