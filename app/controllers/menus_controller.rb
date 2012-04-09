class MenusController < ApplicationController

  set_tab :menu, :sub, :only => [:index, :new, :create, :edit, :update, :reorder]
  before_filter :find_project
  before_filter :find_menu, :only =>[:show, :rename, :edit, :update, :destroy]

  def index
    @menus = @project.menus
  end

  # 增加菜单
  def new
    @menu = Menu.new
    @reports = @project.reports
    @menus = Menu.project_menus @project
    @menu.project_id = params[:project_id]
    if request.xhr?
      render :partial => 'new', :layout => 'popup'
    end
  end

  def show
    @menus = @project.menus
    if @menu.reports.present?
      redirect_to report_project_menu_path(@project, @menu, :report_id => @menu.reports.first.id)
    end
  end

  #
  def rename
    if request.xhr?
      render :partial => 'rename', :layout => 'popup'
    end
  end

  #
  def edit
    @menus = Menu.project_menus @project
    @reports = @project.reports
    if request.xhr?
      render :partial => 'edit', :layout => 'popup'
    end
  end

  #
  def create
    @menu = Menu.new(params[:menu])
    @menu.status = Menu::STATUS_CUSTOM
    @menu.create_association(params[:report_id])
    redirect_to project_menus_path(@menu.project), :notice => t("project.menu.create.success")
  end

  #
  def update
    @menu.update_association(params[:menu], params[:report_id])
    redirect_to project_menus_path(@menu.project), :notice => t("project.menu.update.success")
  end


  def reorder
    if request.get?
      @project = Project.find_by_id(params[:project_id])
      @menus = @project.menus
      @reports = @project.reports
    elsif request.post?
      Menu.reorder(params[:menu])
      redirect_to project_menus_path(@project), :notice => t("project.menus.reorder.success")
    end
  end

  #
  def destroy
    @menu.destroy
    redirect_to project_menus_path(@menu.project)
  end

  def report
    @menus = @project.menus
    @menu = @menus.find_by_id(params[:id])
    @report = @menu.reports.find(params[:report_id])
  end

  private

  def find_project
    @project = Project.find_by_id(params[:project_id])
  end

  def find_menu
    @menu = @project.menus.find(params[:id])
  end

end
