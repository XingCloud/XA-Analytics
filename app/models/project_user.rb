class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates_presence_of :project_id, :user_id
  serialize :privilege, JSON

  def js_attributes
    attributes.merge({"username"=>User.find(user_id).name, "projectname"=>Project.find(project_id).name})
  end

end
