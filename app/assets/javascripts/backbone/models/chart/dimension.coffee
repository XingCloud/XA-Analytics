class Analytics.Models.DimensionChart extends Backbone.Model
  fetch_params: () ->
    metric = Instances.Collections.metrics.get(@get("metric_id"))
    metric_options = {
      id: metric.id.toString()
      end_time: Analytics.Utils.formatUTCDate(@selector.get_end_time(), "YYYY-MM-DD")
      start_time: Analytics.Utils.formatUTCDate(@selector.get_end_time() - (@selector.get("length") - 1) * 86400000, "YYYY-MM-DD")
      interval: @selector.get("interval").toUpperCase()
      type: "GROUP"
      project_id: Instances.Models.project.get("identifier")
    }
    if @selector.get_dimension().dimension_type == "USER_PROPERTIES"
      name = @selector.get_dimension().value
      user_attribute = _.find(Analytics.Static.getUserAttributes(), (item) -> item.name == name)
      if user_attribute?
        if user_attribute.atype == "sql_bigint" and user_attribute.gpattern?
          metric_options["slice_pattern"] = user_attribute["gpattern"]
          metric_options["slice_type"] = "NUMERIC"
        else if user_attribute.atype == "sql_datetime" and user_attribute.gpattern?
          metric_options["slice_pattern"] = user_attribute["gpattern"]
          metric_options["slice_type"] = "DATED"
    sequence_options = metric.sequence_options(@collection.segment_id, @collection.filters)
    for item in sequence_options.items
      item["groupby"] = @selector.get_dimension().value
      item["groupby_type"] = @selector.get_dimension().dimension_type.toUpperCase()
    _.extend(metric_options, sequence_options)
