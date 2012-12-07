class ProjectsController < ProjectBaseController
  before_filter :filter_v9, :only => [:update_project_widgets]

  def show
    fetch_project_members
    @user = User.find_by_name(session[:cas_user])
  end

  def event_item
    @default_value = params[:condition][params[:target_row]] rescue nil
    json = AnalyticService.check_event_key(@project, params[:target_row], params[:condition])
    
    @items = json["data"]["items"]
    render :json => @items
  end

  def timelines
    resp = AnalyticService.request_data(@project, params[:request])
    render :json => {:id => params[:request_id].to_i,
                     :data => resp[:results],
                      :err_code => resp[:err_code],
                      :err_msg => resp[:err_msg]},
           :status => resp[:status]
  end

  def dimensions
    resp = AnalyticService.request_dimensions(@project, params[:request])
    render :json => {:id => params[:request_id].to_i,
                     :data => resp[:results],
                     :err_code => resp[:err_code],
                     :err_msg => resp[:err_msg]},
           :status => resp[:status]
  end

  def ups
    render :json => AnalyticService.ups(@project)
  end

  def update_project_widgets
    error = false
    ProjectWidget.transaction do
      begin
        JSON.parse(params[:project_widgets]).each do |project_widget_attributes|
          project_widget = @project.project_widgets.find(project_widget_attributes["id"])
          project_widget.update_attributes!(project_widget_attributes)
        end
      rescue
        error = true
        raise ActiveRecord::Rollback
      end
    end
    render :json => {}, :status => (error ? 400 : 200)
  end

  def fetch_project_members
    users = BasisService.get_members(@project.identifier)
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
                                          :privilege=>{:report_ids=>[]}})
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
