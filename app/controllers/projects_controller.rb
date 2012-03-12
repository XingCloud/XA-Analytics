class ProjectsController < ApplicationController
  before_filter :find_project, :only => [:show]
  set_tab :project, :sidebar
  
  def index
    @projects = Project.paginate(:page => params[:page])
    render :layout => "welcome"
  end
  
  def show
    @menus = Menu.all
  end

  
  private
  
  def find_project
    @project = Project.find(params[:id])
  end
end
