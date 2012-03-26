class UsersController < ApplicationController
  layout 'menu'
  #before_filter :authenticate_user!
  load_and_authorize_resource
  def index
    @users = User.paginate(:page => params[:page], :per_page => 50)
  end

  def new_role

  end

  # 分配角色
  def assign_role
    @user = User.find(params[:id])
    @user.asign_role(params[:role])
    redirect_to users_path
  end

  def edit_role
    @user = User.find(params[:id])
    @roles = Role.all
  end

  def update_role
    @user = User.find(params[:id])
    @user.update_role(params[:role])
    redirect_to users_path
  end

  def sign_out
    redirect_to CASClient::Frameworks::Rails::Filter.logout_url
  end

end
