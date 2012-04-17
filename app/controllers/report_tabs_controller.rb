class ReportTabsController < ApplicationController
  before_filter :find_report_tab, :only => [:data]
  before_filter :json_header, :only =>[:data]

  def data
    service = AnalyticService.new()
    segment = Segment.find_by_id(params[:segment_id])
    metric = Metric.find(params[:metric_id])
    options = {
        :project_id => @project.identifier,
        :start_time => params[:start_time],
        :end_time => params[:end_time],
        :interval => params[:interval],
        :segment => (segment.to_hsh.to_json unless segment.blank?)
    }
    render :json => build_results(segment, service.request_metric_data(options, metric))
  rescue Exception => e
    render :json => build_results(segment, {:result => false, :error => e.message})
  end

  private

  def build_results(segment, result)
    result.merge({
      :compare => params[:compare] == "true",
      :project_id => @project.id,
      :report_id => @report.id,
      :report_tab_id => @report_tab.id,
      :segment_id => (params[:segment_id] unless segment.blank?),
      :metric_id => params[:metric_id]
    })
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
