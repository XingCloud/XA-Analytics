class ReportsController < ProjectBaseController
  set_tab :report, :sub
  before_filter :find_report, :only => [:show, :edit, :update, :destroy]
  
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
    render :layout => "application"
  end
  
  def request_data
    render :json => {:result => true, :data => [["2011-02-03", 55], ["2011-02-04", 56], ["2011-02-05", 88]]}
  end
  
  private
  
  def find_report
    @report = @project.reports.find(params[:id])
  end
  
end
