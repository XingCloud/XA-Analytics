class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates_presence_of :project_id, :user_id
  serialize :privilege, JSON

  def js_attributes
    project = Project.find(project_id)
    user = User.find(user_id)
    attributes.merge({"username"=>user.name, "email"=>user.email, "project_name"=>project.name, "project_identifier"=>project.identifier})
  end

end
