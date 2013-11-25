class ProjectUsersController < ProjectBaseController
  before_filter :find_project_user, :only =>[:show, :edit, :update, :destroy]

  def index
    render :json => @project.project_users.map(&:js_attributes) # return project_users instead of users for historical issue
  end

  def update
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
  end

  def destroy  # remove user from this project
    if @project_user.destroy
      render :json => @project_user.js_attributes
    else
      render :json => @project_user.js_attributes, :status => 500
    end
  end

  def show
  end

  def edit
  end

  def new
  end

  def create # add user to this project(we create user in user controller)
    @user = User.find_by_email(params[:email])
    if not @user.nil? # check if the user was exist
      @project.project_users.create!(:user_id=>@user.id, :role=> "normal", :privilege=>{:report_ids=>[]})
    end
  end

private
  def find_project_user
    @project_user = @project.project_users.find(params[:id])
  end

  def find_project
    @project = Project.find(params[:project_id])
  end
end
