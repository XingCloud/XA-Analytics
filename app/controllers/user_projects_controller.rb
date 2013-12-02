class UserProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_login_user
  before_filter :find_user

  def index # return all the projects the specified user is in
    #自己可以获取自己所在的所有项目，管理员可以帮别人获取ta所在的所有项目
    if @login_user.id == @user.id or @login_user.role == "admin"
      if @user.role == "admin"
        user_projects=[]
        Project.all.each { |project|
          user_projects.append({"user_id" => @user.id, "project_id" => project.id, "username" => @user.name, "project_name" => project.name, "project_identifier"=>project.identifier})
        }
        render :json => user_projects
      else
        render :json => @user.project_users.map(&:js_attributes)
      end
    else
      render :json=>{}, :status => 403
    end
  end

  def create # create a project and add to the specified user
    #自己可以给自己创建项目，管理员可以帮别人创建项目
    if @login_user.id == @user.id or @login_user.role == "admin"
      project = Project.create(:name=>params[:name], :identifier=>params[:identifier])
      Project.transaction do
        begin
          project.save!
          if @user.project_users.find_by_project_id(project.id).nil?
            @user.project_users.create!(:project_id=>project.id, :role=>"admin", :privilege=>{:report_ids=>[]})
          end
          render :json =>{}
        rescue ActiveRecord::RecordInvalid
          render :json => {}, :status=>400
          raise ActiveRecord::Rollback
        rescue Exception =>e
          logger.error e.message
          logger.error e.backtrace.inspect
          render :json=>{}, :status=>500
        end
      end
    else
      render :json=>{}, :status=>403
    end
  end

  def destroy # remove a project( we can do this only if this user has the 'admin' role on this project)
    project = Project.find(params[:id])
    project_user = @user.project_users.find_by_project_id(params[:id])

    #自己可以删除自己创建的项目，管理员可以帮别人删除ta创建的项目
    if (@login_user.id == @user.id or @login_user.role == "admin") and project_user.role == "admin"
      if project.destroy
        render :json=>project.js_attributes
      else
        render :json=>{}, :status => 500
      end
    else
      render :json=>{}, :status => 403
    end

  end

private
  def find_login_user
    @login_user = current_user
  end

  def find_user #user we are dealing with
    @user = User.find(params[:user_id])
  end
end