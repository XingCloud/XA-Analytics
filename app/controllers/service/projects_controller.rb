class Service::ProjectsController < Service::BaseController
  before_filter :find_project

  def sync_metrics
    metrics = []
    @project.project_reports.visible.each do |project_report|
      report = Report.find(project_report.report_id)
      report.report_tabs.each do |report_tab|
        report_tab.metrics.each do |metric|
          metrics.append(metric.sync_json(report_tab.interval.upcase))
          metrics.append(metric.combine.sync_json(report_tab.interval.upcase)) unless metric.combine.blank?
          if report_tab.dimensions.length > 0
            groupby_json = report_tab.dimensions_sequence
            metrics.append(metric.sync_json(report_tab.interval.upcase, groupby_json))
            metrics.append(metric.combine.sync_json(report_tab.interval.upcase, groupby_json)) unless metric.combine.blank?
          end
        end
      end
    end
    render :json => metrics.uniq
  end

  private

  def find_project
    @project = Project.fetch(params[:id])
  end
end