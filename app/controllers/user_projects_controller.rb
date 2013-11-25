class UserProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user

  def index # return all the projects this user is in
    render :json => @user.project_users.map(&:js_attributes)
  end

  def create # create a project and add to this user
    @project = Project.create(params[:project])
    Project.transaction do
      begin
        @project.save!
        if @user.project_users.find_by_project_id(@project.id)
          @user.project_users.create!(:project_id=>@project.id, :role=>"admin", :privilege=>{:report_ids=>[]})
        end
      rescue

      end
    end
  end

  def destroy # remove a project( we can do this only if this user is has the 'admin' role on this project)
    @project = Project.find(params[:id])
    @project_user = @user.project_users.find_by_project_id(params[:id])
    if @project_user.role == "admin"
      if @project.destroy
        render :json=>@project_user.js_attributes
      else
        render :json=>{}, :status => 500
      end
    else
      render :json=>{}, :status => 400
    end

  end

private
  def find_user
    @user = current_user
  end
end