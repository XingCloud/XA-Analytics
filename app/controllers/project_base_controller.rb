class ProjectBaseController < ApplicationController
  before_filter :find_project
  
  protected
  
  def find_project
    @project = Project.find(params[:project_id])
  end
end