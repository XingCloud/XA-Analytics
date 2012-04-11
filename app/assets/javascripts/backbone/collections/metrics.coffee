class Analytics.Collections.Metrics extends Backbone.Collection
  model: Analytics.Models.Metric

  updateItem: (metric_options) ->
    @find((metric) -> metric.get("id") == metric_options.id).set(metric_options)