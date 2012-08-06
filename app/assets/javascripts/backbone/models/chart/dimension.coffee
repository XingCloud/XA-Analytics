class Analytics.Models.DimensionChart extends Backbone.Model
  fetch_params: () ->
    metric = metrics_router.get(@get("metric_id"))
    metric_options = {
      id: metric.id.toString()
      end_time: Analytics.Utils.formatUTCDate(@selector.get_end_time(), "YYYY-MM-DD")
      start_time: Analytics.Utils.formatUTCDate(@selector.get_end_time() - (@selector.get("length") - 1) * 86400000, "YYYY-MM-DD")
      interval: @selector.get("interval").toUpperCase()
      type: "GROUP"
      project_id: project.get("identifier")
    }
    sequence_options = metric.sequence_options(@collection.segment_id, @collection.filters)
    for item in sequence_options.items
      item["groupby"] = @selector.get_dimension().value
      item["groupby_type"] = @selector.get_dimension().dimension_type.toUpperCase()
    _.extend(metric_options, sequence_options)
