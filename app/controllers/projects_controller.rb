class ProjectsController < ApplicationController
  skip_before_filter :cas_filter, :only => :index
  #before_filter CASClient::Frameworks::Rails::GatewayFilter, :only => :index

  before_filter :find_project, :only => [:show, :members, :event_item]
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
  
  def event_item
    @default_value = params[:condition][params[:target_row]] rescue nil
    json = AnalyticService.check_event_key(@project, params[:target_row], params[:condition])
    pp json
    @items = ["visit", "pay", "good"] * 3
    render :layout => false
  end

  private

  def find_project
    @project = Project.find_by_id(params[:id]) || Project.find_by_identifier(params[:id])
  end
end