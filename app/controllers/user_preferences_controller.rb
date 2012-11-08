class UserPreferencesController < ApplicationController
  def index
    render :json => UserPreference.where({:user => session[:cas_user]}).map(&:attributes)
  end

  def create
    @user_preference = UserPreference.new({:user => session[:cas_user]}.merge(params[:user_preference]))
    if @user_preference.save!
      render :json => @user_preference.attributes
    else
      render :json => @user_preference.attributes, :status => 400
    end
  end

  def update
    @user_preference = UserPreference.find(params[:id])
    if @user_preference.update_attributes(params[:user_preference])
      render :json => @user_preference.attributes
    else
      render :json => @user_preference.attributes, :status => 400
    end
  end
end