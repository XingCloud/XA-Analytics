class ReportsController < ProjectBaseController
  set_tab :add_report, :sub
  before_filter :find_report, :only => [:edit, :update, :destroy]
  
  def index
    @reports = @project.reports.paginate(:page => params[:page])
  end
  
  def new
    @report = @project.reports.create
    redirect_to edit_project_report_path(@project, @report)
  end
  
  def edit
    
  end
  
  def update
    report_type = params[:report].delete(:type)
    @report.update_column("type", report_type)
    
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
