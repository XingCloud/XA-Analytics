class MenusController < ApplicationController
  set_tab :menu, :sub, :only => [:index, :new, :create, :edit, :update, :reorder]
  before_filter :find_project, :only=>[:index, :new, :show, :report]
  
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
    @menus = @project.menus
    @menu = @menus.find(params[:id])
    if @menu.reports.present?
      redirect_to report_project_menu_path(@project, @menu, :report_id => @menu.reports.first.id)
    end
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
  
  def report
    @menus = @project.menus
    @menu = @menus.find(params[:id])
    @report = @menu.reports.find(params[:report_id])
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

end
