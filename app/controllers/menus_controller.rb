class MenusController < ApplicationController
  set_tab :add_menu, :sub
  before_filter :find_project
  def index
    @menus = Menu.all
  end

  # 增加菜单
  def new
    @menu = Menu.new
  end

  #
  def edit

  end

  #
  def create
    @menu = Menu.create(params[:menu])
    redirect_to project_path(@project)
  end

  #
  def update
    
  end

  #
  def destroy

  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

end
