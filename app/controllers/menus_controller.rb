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
    if request.xhr?
      render :partial => 'new' ,:layout => 'popup'
    end
  end

  def show
    @menu = Menu.find(params[:id])
    @common_menus = Menu.all(:conditions => ["status = ? and parent_id is null ", Menu::STATUS_DEFAULT])
    @menus = @project.menus

    if @menu.reports.present?
      redirect_to report_project_menu_path(@project, @menu, :report_id => @menu.reports.first.id)
    end
  end

  #
  def edit
    @menu = Menu.find(params[:id])
    @project = @menu.project
    @report = @project.reports
    if request.xhr?
      render :partial => 'edit',:layout => 'popup'
    end
  end

  #
  def create
    @menu = Menu.new(params[:menu])
    @menu.status = Menu::STATUS_CUSTOM
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
    if request.xhr?
      render :partial => 'reorder',:layout => 'popup'
    end
  end

  #
  # TODO
  def destroy
    @menu = Menu.find(params[:id])
    if @menu.status == Menu::STATUS_CUSTOM && @menu.project == @project
        @menu.destroy
    end
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
