module Workers
  module SyncReport
    @queue = :sync_report

    def self.perform(metrics, action = "SAVE_OR_UPDATE")
      AnalyticService.sync_metric(action, metrics) unless metrics.length == 0
    end

    def self.params(report_id)
      report = Report.find(report_id)
      metrics = []
      report.report_tabs.each do |report_tab|
        if report_tab.dimensions.length > 0
          groupby_json = report_tab.dimensions_sequence
          report_tab.metrics.each do |metric|
            metrics.append(metric.sequence("GROUP", groupby_json.to_json.gsub(/"/, "'")))
          end
        end
      end
      metrics
    end
  end
end