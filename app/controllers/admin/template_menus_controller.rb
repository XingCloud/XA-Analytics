class Admin::TemplateMenusController < ApplicationController
  layout 'admin'
  before_filter :find_reports, :only => [:new, :edit]
  set_tab :template_menus, :sidebar

  def index
    @menus = Menu.all(:conditions => {:status => Menu::STATUS_DEFAULT})
  end

  #
  def new
    @menu = Menu.new
    @menus = Menu.parent_menus
    if request.xhr?
      render :partial => 'new', :layout => 'popup'
    end
  end

  #
  def rename
    @menu = Menu.find_by_id(params[:id])
    if request.xhr?
      render :partial => 'rename', :layout => 'popup'
    end
  end

  #
  def reorder
    if request.get?
      @menus = Menu.parent_menus
    elsif request.post?
      Menu.reorder(params[:menu])
      redirect_to admin_template_menus_path
    end
  end

  def edit
    @menu = Menu.find_by_id(params[:id])
    @menus = Menu.parent_menus
    if request.xhr?
      render :partial => 'edit', :layout => 'popup'
    end
  end

  def update
    @menu = Menu.find_by_id(params[:id])
    if @menu.update_association(params[:menu], params[:report_id])
      redirect_to admin_template_menus_path
    else
      redirect_to edit_admin_template_menus_path
    end

  end

  def create
    @menu = Menu.new(params[:menu])
    @menu.status = Menu::STATUS_DEFAULT
    menu = @menu.create_association(params[:report_id])
    if menu
      redirect_to admin_template_menus_path
    else
      redirect_to new_admin_template_menu_path
    end
  end

  def destroy
    @menu = Menu.find_by_id(params[:id])
    @menu.destroy
    redirect_to admin_template_menus_path
  end

  private

  # TODO
  def find_reports
    @reports = Report.all(:conditions => ["template = ?", Report::COMMON_TEMPLATE])
  end

end