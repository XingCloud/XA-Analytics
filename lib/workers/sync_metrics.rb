module Workers
  module SyncMetrics
    @queue = :sync_metrics

    def self.perform(metrics, action = "SAVE_OR_UPDATE")
      AnalyticService.sync_metric(action, metrics)
    end
  end
end
