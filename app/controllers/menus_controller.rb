class MenusController < ApplicationController
  before_filter :find_project, :only=>[:index, :new, :show]

  def index
    @menus = @project.menus
  end

  # 增加菜单
  def new
    @menu = Menu.new
    @report = @project.reports
    @menu.project_id = params[:project_id]
  end

  def show
    @menu = Menu.find(params[:id])
    @menus = @project.menus
  end

  #
  def edit
    @menu = Menu.find(params[:id])
    @project = @menu.project
    @report = @project.reports
  end

  #
  def create
    @menu = Menu.new(params[:menu])
    @menu.create_association(params[:report_id])
    redirect_to project_menus_path(@menu.project)
  end

  #
  def update
    @menu = Menu.find(params[:id])
    @menu.update_association(params[:menu], params[:report_id])
    redirect_to project_menus_path(@menu.project)
  end


  def reorder
    if request.get?
      @project = Project.find(params[:project_id])
      @menus = @project.menus
      @report = @project.reports
    elsif request.post?
      Menu.reorder(params[:menu])
      redirect_to project_menus_path(Project.find params[:project_id])
    end
  end

  #
  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    redirect_to project_menus_path(@menu.project)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

end
