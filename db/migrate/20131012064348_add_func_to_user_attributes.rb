class AddFuncToUserAttributes < ActiveRecord::Migration
  def change
    add_column :user_attributes, :func, :string
  end
end
