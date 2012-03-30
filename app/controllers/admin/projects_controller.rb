class Admin::ProjectsController < ApplicationController
  set_tab :project, :sidebar

  def index
    @projects = Project.paginate(:page => params[:page])
    render :layout => "admin"
  end

end