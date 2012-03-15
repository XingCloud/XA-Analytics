class MenusController < ApplicationController
#  layout "menu"
  before_filter :find_project,:only=>[:index,:new]
  def index
    @menus = @project.menus
  end

  # 增加菜单
  def new
    @menu = Menu.new
    @report = @project.reports
    @menu.project_id = params[:project_id]
  end

  #
  def edit
    @menu = Menu.find(params[:id])
  end

  #
  def create
    @menu = Menu.new(params[:menu])
    @menu.save
    redirect_to project_path(@menu.project)
  end

  #
  def update
    @menu = Menu.find(params[:id])
    @menu.update_attributes(params[:menu])
    redirect_to project_path(@menu.project)
  end


  def reorder
    if request.get?
      @project = Project.find(params[:project_id])
      @menus = @project.menus
    elsif request.post?
      Menu.reorder(params[:menu])
      redirect_to project_path(:id => params[:project_id])
    end
  end

  #
  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    redirect_to project_path(@menu.project)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

end
