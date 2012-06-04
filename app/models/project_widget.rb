class ProjectWidget < ActiveRecord::Base
  belongs_to :project
  belongs_to :widget

  validates_presence_of :widget_id, :project_id, :display
  validates_numericality_of :display, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :px, :only_integer => true, :greater_than_or_equal_to => 0, :if => proc{|m| m.px.present? }
  validates_numericality_of :py, :only_integer => true, :greater_than_or_equal_to => 0, :if => proc{|m| m.py.present? }

  scope :visible, where(:display => 1)
end
