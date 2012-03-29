class ProjectsController < ApplicationController
  skip_before_filter :cas_filter, :only => :index
  #before_filter CASClient::Frameworks::Rails::GatewayFilter, :only => :index

  before_filter :find_project, :only => [:show, :members]
  set_tab :project, :sidebar

  def index
    @projects = Project.paginate(:page => params[:page])
    render :layout => "welcome"
  end

  def show
    @menus = @project.menus
    @menu = @menus.detect{|menu| menu.leaf? }
    if @menu && @menu.reports.present?
      redirect_to project_menu_path(@project, @menu)
    end

  end

  private

  def find_project
    @project = Project.find_by_id(params[:id]) || Project.find_by_identifier(params[:id])
  end
end