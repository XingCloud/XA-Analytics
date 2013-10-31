class AddSqlAndMannerToSegments < ActiveRecord::Migration
  def change
    add_column :segments, :sql, :text
    add_column :segments, :manner, :string, :default => "formula"
  end
end
