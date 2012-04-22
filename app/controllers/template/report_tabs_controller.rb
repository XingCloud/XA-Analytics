class Template::ReportTabsController < ApplicationController
  before_filter :find_report_tab, [:show]

  def show
    render :json => @report_tab.js_attributes
  end

  private

  def find_report_tab
    @report = Report.find(params[:report_id])
    @report_tab = @report.report_tabs.find(params[:id])
  end
end