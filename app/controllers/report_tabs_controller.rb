class ReportTabsController < ApplicationController
  before_filter :find_report_tab, :only => [:data]
  before_filter :json_header, :only =>[:data]

  def data
    service = AnalyticService.new()
    segment = Segment.find_by_id(params[:segment_id])
    params[:segment] =  segment.to_hsh.to_json unless segment.blank?
    render :json => build_results(0, service.request_metrics_data(@project.identifier, params, @report_tab.metrics), "")
  rescue Timeout::Error => e
    render :json => build_results(-1, {}, e.message)
  rescue Exception => e
    render :json => build_results(-100, {}, e.message)
  end

  private

  def build_results(status, data, error)
    {
      :status => status,
      :data => data,
      :error => error,
      :project_id => @project.id,
      :report_id => @report.id,
      :report_tab_id => @report_tab.id
    }
  end


  def find_report_tab
    @project = Project.find(params[:project_id])
    @report = Report.find(params[:report_id])
    @report_tab = @report.report_tabs.find(params[:id])
  end

  def json_header
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
  end
end
