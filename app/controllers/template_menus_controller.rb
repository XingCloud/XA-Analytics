class TemplateMenusController < ApplicationController
  layout 'menu'
  before_filter :find_reports, :only => [:new, :edit]

  def index
    @menus = Menu.all(:conditions => {:status => Menu::STATUS_DEFAULT})
  end

  #
  def new
    @menu = Menu.new
    if request.xhr?
      render :partial => 'new', :layout => 'popup'
    end
  end

  #
  def reorder
    if request.get?
      @menus = Menu.all(:conditions => ["status = ? and parent_id is null ", Menu::STATUS_DEFAULT])
    elsif request.post?
      Menu.reorder(params[:menu])
      redirect_to template_menus_path
    end
    if request.xhr?
      render :partial => 'reorder', :layout => 'popup'
    end
  end

  def edit
    @menu = Menu.find_by_id(params[:id])
    if request.xhr?
      render :partial => 'edit', :layout => 'popup'
    end
  end

  def update
    @menu = Menu.find_by_id(params[:id])
    if @menu.update_association(params[:menu], params[:report_id])
      redirect_to template_menus_path
    else
      redirect_to edit_template_menus_path
    end

  end

  def create
    @menu = Menu.new(params[:menu])
    @menu.status = Menu::STATUS_DEFAULT
    @menu.create_association(params[:report_id])
    if @menu.save
      redirect_to template_menus_path
    else
      redirect_to new_template_menu_path
    end
  end

  def destroy
    @menu = Menu.find_by_id(params[:id])
    if @menu.status == Menu::STATUS_DEFAULT && current_user.admin
      @menu.destroy
    end
  end

  private

  # TODO
  def find_reports
    @reports = Report.all(:conditions => ["template = ?",Report::COMMON_TEMPLATE])
  end

end