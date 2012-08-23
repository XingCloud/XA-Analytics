class ProjectReportCategory < ActiveRecord::Base
  belongs_to :project
  belongs_to :report_category

  validates_presence_of :project_id, :report_category_id
  validates_numericality_of :position, :only_integer => true, :if => proc{|prc|prc.position.present?}
  scope :visible, where(:display => true)
end
