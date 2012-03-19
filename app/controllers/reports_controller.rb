class ReportsController < ProjectBaseController
  set_tab :report, :sub
  before_filter :find_report, :only => [:edit, :update, :destroy]
  
  def index
    @reports = @project.reports.paginate(:page => params[:page])
  end
  
  def new
    @report = @project.reports.build
  end
  
  def edit
    
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
  
  private
  
  def find_report
    @report = @project.reports.find(params[:id])
  end
end
