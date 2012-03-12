class MenusController < ApplicationController
  layout 'menu'
  def index
    @menus = Menu.all
    p @menus
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
    redirect_to :action => "index"
  end

  #
  def update
    
  end

  #
  def destroy

  end

end
