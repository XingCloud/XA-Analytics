class ProjectUsersController < ProjectBaseController
  before_filter :find_project_user, :only =>[:show, :edit, :update, :destroy]
  
  def index
    refresh_users
    render :json => @project.project_users.map(&:js_attributes)
  end

  def update
    ProjectUser.transaction do
      begin
        @project_user.update_attributes!(param[:project_user])
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

  def destroy
    if @project_user.destroy
      render :json => @project_user.js_attributes
    else
      render :json => @project_user.js_attributes, :status => 500
    end
  end

private
  def find_project_user
    @project_user = @project.project_users.find(params[:id])
  end

  def refresh_users
    users = BasisService.get_users(@project.identifier)
    users.each do |user|
      if not User.find_by_name(user).nil?
        next
      end
      @user = User.new({:name=>user})
      User.transaction do
        begin
          @user.save!
          @project.project_users.create!({
                                          :user_id=>@user.id,
                                          :role=>"normal",
                                          :privilege=>{:reports=>{}}})
        rescue ActiveRecord::RecordInvalid

          raise ActiveRecord::Rollback
        rescue Exception => e
          logger.error e.message
          logger.error e.backtrace.inspect          
        end
      end #end transaction
    end #end each 
  end

end
