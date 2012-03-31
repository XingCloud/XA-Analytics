class Admin::TemplateMenusController < ApplicationController
  layout 'admin'
  before_filter :find_reports, :only => [:new, :edit]
  set_tab :template_menus, :sidebar
  before_filter :find_menu, :only => [:rename, :edit, :update, :destroy]

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
    @menus = Menu.parent_menus
    if request.xhr?
      render :partial => 'edit', :layout => 'popup'
    end
  end

  def update
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
    @menu.destroy
    redirect_to admin_template_menus_path
  end

  private


  def find_reports
    @reports = Report.template
  end

  def find_menu
    @menu = Menu.find_by_id(params[:id])
  end

end