class ProjectsController < ProjectBaseController
  before_filter :filter_v9, :only => [:update_project_widgets]

  def show
    fetch_project_members
    Resque.enqueue(Workers::LogVisit, @project.id, session[:cas_user])
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

  def description
    attributes = @project.attributes
    attributes.merge!({
      :user_count => BasisService.get_members(@project.identifier).length,
      :report_count => calc_report_count,
      :metric_count => @project.metrics.where(:combine_id => nil).length + Metric.template.where(:combine_id => nil).length,
      :segment_count => @project.segments.length + Segment.template.length,
      :action_logs => @project.action_logs.paginate(:page => 1, :per_page => 3, :order => "perform_at DESC")
    })
    render :json => attributes
  end

  private

  def fetch_project_members
    users = BasisService.get_members(@project.identifier)
    users.each do |user|
      @user = User.find_by_name(user)
      if @user.nil?
        @user = User.new({:name=>user})
      end
      User.transaction do
        begin
          @user.save!
          if @project.project_users.find_by_user_id(@user.id).nil?
            @project.project_users.create!({
                                             :user_id=>@user.id,
                                             :role=>"normal",
                                             :privilege=>{:report_ids=>[]}})
          end
        rescue ActiveRecord::RecordInvalid

          raise ActiveRecord::Rollback
        rescue Exception => e
          logger.error e.message
          logger.error e.backtrace.inspect          
        end
      end #end transaction
    end #end each 
  end

  def calc_report_count
    count = 0
    (Report.template | Report.where({:project_id => @project.id})).each do |report|
      project_report = @project.project_reports.find_by_report_id(report.id)
      if project_report.blank? or project_report.display
        count = count + 1
      end
    end
    count
  end
end
