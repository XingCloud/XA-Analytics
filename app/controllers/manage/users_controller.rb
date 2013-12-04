class Manage::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user
  layout "manage"

  def index

  end

  def list
    if @login_user.role == "admin"
      render :json => User.all.map(&:js_attributes)
    else
      render :json=>nil, :status=> 403
    end
  end

  def update

  end

  def destroy
    if @login_user.role == "admin"

    else

    end
  end


private
  def find_user
    @login_user = current_user
  end

end