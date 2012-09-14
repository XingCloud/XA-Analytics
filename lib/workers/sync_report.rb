module Workers
  module SyncReport
    @queue = :sync_report

    def self.perform(report_id, action = "SAVE_OR_UPDATE")
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
      AnalyticService.sync_metric(action, metrics) unless metrics.length == 0
      if action == "REMOVE"
        raise "destroy error" unless report.destroy
      end
    end
  end
end