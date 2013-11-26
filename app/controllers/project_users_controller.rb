class ProjectUsersController < ProjectBaseController #TODO wcl don't inherit from project
  before_filter :find_login_user
  before_filter :find_project_user, :only =>[:show, :edit, :update, :destroy]

  def index
    # 项目管理员/成员可以获取该项目的所有用户，管理员可以获取任意项目的所有用户
    if @login_user.role == "admin" or (@login_user.id == @user.id and not @login_user.project_users.find_by_project_id(@project.id).nil?)
      render :json => @project.project_users.map(&:js_attributes) # return project_users instead of users for historical issue
    else
      render :json=>{}, :status=>400
    end
  end

  def update
    project_user =  @user.project_users.find_by_project_id(params[:project_id])
    if @login_user.role == "admin" or (@login_user.id == @user.id and project_user.role == "admin") #
      ProjectUser.transaction do
        begin
          @project_user.update_attributes!(params[:project_user])
          render  :json=> @project_user.js_attributes
        rescue ActiveRecord::RecordInvalid
          render :json => @project_user.js_attributes, :status=>400
          raise ActiveRecord::Rollback
        rescue Exception => e
          logger.error e.message
          logger.error e.backtrace.inspect
          render :json => @project_user.js_attributes, :status => 500
          raise ActiveRecord::Rollback
        end
      end
    else
      render :json=>{}, :status=>400
    end
  end

  def destroy  # remove user from this project

    if @login_user.role == "admin" or @login_user.project_user.find(params[:project_id]).role=="admin"
      if @project_user.destroy
        render :json => @project_user.js_attributes
      else
        render :json => @project_user.js_attributes, :status => 500
      end
    else
      render :json=>{}, status=>400
    end
  end

  def show
  end

  def edit
  end

  def new
  end

  def create # add user to this project(we create user in user controller)
    if @login_user.role == "admin" or @login_user.project_user.find(params[:project_id]).role=="admin"
      @user = User.find_by_email(params[:email])
      if not @user.nil? # check if the user was exist
        @project.project_users.create!(:user_id=>@user.id, :role=> "normal", :privilege=>{:report_ids=>[]})
      end
    else
      render :json=>{}, status=>400
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
