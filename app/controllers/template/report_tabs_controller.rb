class Template::ReportTabsController < Template::BaseController
  before_filter :find_report_tab, :only => [:show]
  before_filter :json_header

  def show
    render :json => @report_tab.js_attributes
  end

  private

  def find_report_tab
    @report = Report.find(params[:report_id])
    @report_tab = @report.report_tabs.find(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end
end