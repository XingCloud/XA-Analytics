class ActionLog < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project_id, :resource_type, :resource_name, :action, :user, :perform_at
end
