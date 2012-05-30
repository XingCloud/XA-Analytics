class WidgetConnector < ActiveRecord::Base
  belongs_to :project
  belongs_to :widget

  validates_presence_of :widget_id, :project_id, :display

  scope :visible, where(:display => 1)
end
