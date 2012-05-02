class Analytics.Collections.Metrics extends Backbone.Collection
  model: Analytics.Models.Metric

  batch_add: (metrics_options) ->
    for metric_options in metrics_options
      @add(new Analytics.Models.Metric(metric_options))