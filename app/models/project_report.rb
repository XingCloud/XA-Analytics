class ProjectReport < ActiveRecord::Base
  belongs_to :project
  belongs_to :report

  validates_presence_of :project_id, :report_id
  scope :visible, where(:display => true)
end
