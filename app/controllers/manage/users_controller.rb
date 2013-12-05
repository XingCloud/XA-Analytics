class Manage::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_login_user
  before_filter :find_user ,:only=>[:update, :destroy]
  layout "manage"

  def home
    if @login_user.role == "admin"
      render :action=>"index"
    else
      render :json=>{:message=>"have no privilege"}, :status => 403
    end
  end

  def index
    pp request.content_type
    if @login_user.role == "admin"
      render :json => User.all.map(&:js_attributes)
    else
      render :json=>nil, :status=> 403
    end
  end

  def update
    begin
      @user.update_attributes!(params[:user])
      render :json=>@user.js_attributes
    rescue ActiveRecord::RecordInvalid
      render :json => @user.js_attributes, :status => 400
      raise ActiveRecord::Rollback
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace.inspect
      render :json => @user.js_attributes, :status => 500
      raise ActiveRecord::Rollback
    end
  end

  def destroy
    if @login_user.role == "admin"
      if @user.destroy
        render :json=>@user.js_attributes
      else
        render :json=>{}, :status=>500
      end
    else
      render :json=>@user.js_attributes, :status => 403
    end
  end


private
  def find_login_user
    @login_user = current_user
  end

  def find_user
    @user = User.find(params[:id])
  end

end