class ProjectsController < ApplicationController
  before_filter :find_project, :only => [:show, :members, :event_item]
  set_tab :project, :sidebar

  def show
    @menus = @project.menus
    @menu = @menus.detect{|menu| menu.leaf? }
    if @menu
      redirect_to project_menu_path(@project, @menu)
    end
  end
  
  def event_item
    @default_value = params[:condition][params[:target_row]] rescue nil
    json = AnalyticService.check_event_key(@project, params[:target_row], params[:condition])
    
    @items = json["data"]["items"]
    render :layout => false
  end

  private

  def find_project
    @project = Project.fetch(params[:id])
  end
end