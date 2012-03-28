class AddTemplateToReports < ActiveRecord::Migration
  def change
    add_column :reports, :template, :integer

  end
end
