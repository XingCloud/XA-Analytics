class Setting < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id
  validates_numericality_of :project_id
end
