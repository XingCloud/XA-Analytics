class ProjectUsersController < ProjectBaseController #TODO wcl don't inherit from project
  before_filter :find_login_user

  def index
    project_login_user =  @login_user.project_users.find_by_project_id(params[:project_id])

    # 项目非外来用户可以获取该项目的所有用户，管理员可以获取任意项目的所有用户
    if @login_user.role == "admin" or (not project_login_user.nil? and project_login_user.role != "mgriant")
      render :json => @project.project_users.map(&:js_attributes) # return project_users instead of users for historical issue
    else
      render :json=>{}, :status=>403
    end
  end

  def update
    user = User.find(params[:id])
    project_user =  user.project_users.find_by_project_id(params[:project_id])
    if project_user.nil?
      render :json=>{}, :status => 400 #要处理的用户不在该项目内，不用处理
    end
    project_login_user =  @login_user.project_users.find_by_project_id(params[:project_id])

    # 项目管理员可以修改项目成员在该项目的报告权限，管理员可以修改所有用户在ta所在项目的报告权限
    if @login_user.role == "admin" or (not project_login_user.nil? and project_login_user.role == "admin")
      ProjectUser.transaction do
        begin
          project_user.update_attributes!(params[:project_user])
          render  :json=> project_user.js_attributes
        rescue ActiveRecord::RecordInvalid
          render :json => project_user.js_attributes, :status=>400
          raise ActiveRecord::Rollback
        rescue Exception => e
          logger.error e.message
          logger.error e.backtrace.inspect
          render :json => project_user.js_attributes, :status => 500
          raise ActiveRecord::Rollback
        end
      end
    else
      render :json=>{}, :status=>403
    end
  end

  def destroy  # remove user from this project
    user = User.find(params[:id])
    project_user = user.project_users.find_by_project_id(params[:project_id])
    if project_user.nil?
      render :json=>{}, :status => 400 #要处理的用户不在该项目内，不用处理
    end
    project_login_user = @login_user.project_users.find_by_project_id(params[:project_id])

    # 项目管理员可以移除项目成员，管理员可以移除所有项目的所有成员(最后一个项目管理员不能被移除)
    if (@login_user.role == "admin" or (not project_login_user.nil? and project_login_user.role=="admin"))
      if project_user.role == "admin" and @project.project_users.all(:conditions=>{:role=>"admin"}).length==1
        render :json=> {}, :status=>400
        return
      end
      if project_user.destroy
        render :json => project_user.js_attributes
      else
        render :json => project_user.js_attributes, :status => 500
      end
    else
      render :json=>{}, :status=>403
    end
  end

  def create # add user to this project(we create user in user controller)
    project_login_user = @login_user.project_users.find_by_project_id(params[:project_id])
    # 项目管理员可以添加用户到该项目，管理员可以添加任务用户到任意用户
    if @login_user.role == "admin" or project_login_user.role == "admin"
      user = User.find_by_email(params[:email])
      if not user.nil? # check if the user was exist
        project_user = @project.project_users.create!(:user_id=>user.id, :role=> params[:role], :privilege=>{:report_ids=>[]})
        render :json=> project_user.js_attributes
      else
        render :json=>{}, :status=>400
      end
    else
      render :json=>{}, :status=>403
    end
  end

private
  def find_login_user
    @login_user = current_user
  end

  def find_project # project we are dealing with
    @project = Project.find(params[:project_id])
  end
end
