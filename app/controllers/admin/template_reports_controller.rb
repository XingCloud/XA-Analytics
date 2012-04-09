class Admin::TemplateReportsController < Admin::BaseController
  before_filter :find_report, :only => [:edit, :update, :destroy]
  set_tab :template_reports, :sidebar
  
  def index
    @categories = ReportCategory.where(:template => 1).order("position asc").all
    @reports = Report.find_all_by_report_category_id(nil)
  end

  def new
    @report = Report.new
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def find_report
    @report = Report.find(params[:id])
  end
end
