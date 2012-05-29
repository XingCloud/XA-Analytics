class Analytics.Models.DimensionChart extends Backbone.Model
  fetch_params: () ->
    metric = metrics_router.get(@get("metric_id"))
    metric_options = {
      id: metric.id
      end_time: Analytics.Utils.formatUTCDate(@selector.get_end_time(), "yyyy-MM-dd")
      start_time: Analytics.Utils.formatUTCDate(@selector.get_end_time() - (@selector.get("length") - 1) * 86400000, "yyyy-MM-dd")
      interval: @selector.get("interval").toUpperCase()
      groupby: @selector.get_dimension().value
      groupby_type: @selector.get_dimension().dimension_type.toUpperCase()
    }
    _.extend(metric_options, metric.sequence_options(@collection.segment_id, @collection.filters))