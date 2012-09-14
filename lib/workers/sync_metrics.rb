module Workers
  module SyncMetrics
    @queue = :sync_metrics

    def self.perform(metric_ids, action = "SAVE_OR_UPDATE")
      metrics = metric_ids.map{|metric_id| Metric.find(metric_id).sequence}
      AnalyticService.sync_metric(action, metrics)
    end
  end
end
