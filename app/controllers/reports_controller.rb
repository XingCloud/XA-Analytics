class ReportsController < ProjectBaseController
  set_tab :add_report, :sub
  
  def new
    @report = @project.reports.build
  end
  
  def create
    @report = Report.new(params[:report])
  end
  
end
