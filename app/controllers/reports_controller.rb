class ReportsController < ProjectBaseController
  set_tab :report, :sub
  before_filter :find_report, :only => [:show, :edit, :update, :destroy, :request_data]
  
  def index
    @reports = @project.reports.paginate(:page => params[:page])
  end
  
  def new
    @report = @project.reports.build
    @report.build_period
  end
  
  def create
    report_type = params[:report].delete(:type)
    if Report.subclasses.map(&:name).include?(report_type)
      @report = report_type.constantize.new(params[:report])
      @report.project = @project
    else
      @report = @project.reports.build(params[:report])
    end
    
    if @report.save
      redirect_to project_report_path(@project, @report), :notice => t("report.create.success")
    else
      render :new
    end
  end
  
  def update
    report_type = params[:report].delete(:type)
    if Report.subclasses.map(&:name).include?(report_type)
      @report.update_column("type", report_type)
    end
    
    if @report.update_attributes(params[:report])
      redirect_to project_reports_path(@project), :notice => t("report.update.success")
    else
      render :new
    end
  end
  
  def destroy
    @report.destroy
    redirect_to project_reports_path(@project), :notice => t("report.delete.success")
  end
  
  def show
    @default_start_time = @report.start_time
    @default_end_time = @report.end_time
    render :layout => "application"
  end
  
  def request_data
    if params[:test] == "true"
      random_data = (Date.parse(params[:start_time])..Date.parse(params[:end_time])).map {|day|
        [day.to_s, rand(100)]
      }
      
      render :json => {:result => true, :data => random_data}
    else
      @metric = @report.metrics.find(params[:metric_id])
      data = AnalyticService.new(@report, params).request_metric_data(@metric)
      
      render :json => data
    end
  end
  
  private
  
  def find_report
    @report = @project.reports.find(params[:id])
  end
  
end
