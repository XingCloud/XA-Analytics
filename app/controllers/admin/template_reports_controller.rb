class Admin::TemplateReportsController < Admin::BaseController
  before_filter :find_report, :only => [:edit, :update, :destroy, :add_tab, :remove_tab]
  set_tab :template_reports, :sidebar
  
  def index
    @categories = ReportCategory.where(:template => 1).order("position asc").all
    @reports = Report.find_all_by_report_category_id(nil)
  end

  def new
    @report = Report.new
    @report.report_tabs.build
  end

  def create
  end

  def update
  end

  def destroy
  end

  def add_tab
    if @report.nil?
      @report = Report.new(params[:report])
      @report.report_tabs.push(ReportTab.new)
    else
      @report.report_tabs.push(ReportTab.new)
    end

    render "reports/form"

  end

  def remove_tab

  end


  private

  def find_report
    @report = Report.find(params[:id])
  end
end
