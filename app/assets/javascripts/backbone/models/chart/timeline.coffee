class Analytics.Models.TimelineChart extends Backbone.Model
  initialize: (options) ->
    @set({sequence: {
      total: 0
      natural: 0
      rate: 0
      data: []
    }})

  fetch_params: () ->
    if @get("compare_for")?
      end_time = @selector.get_compare_end_time()
    else
      end_time = @selector.get_end_time()
    start_time = end_time - (@selector.get("length") - 1) * 86400000
    metric = metrics_router.get(@get("metric_id"))
    metric_options = metric.sequence_options(@get("segment_id"), @get("filters"))
    _.extend(metric_options, {
      id: @id
      end_time: Analytics.Utils.formatUTCDate(end_time, "yyyy-MM-dd")
      start_time: Analytics.Utils.formatUTCDate(start_time, "yyyy-MM-dd")
      interval: @selector.get("interval").toUpperCase()
      type: "COMMON"
    })

  name: () ->
    if @get("segment_id") != 0
      metrics_router.get(@get("metric_id")).get("name") + "(" + segments_router.get(@get("segment_id")).get("name") + ")"
    else
      metrics_router.get(@get("metric_id")).get("name")

  data: () ->
    if @get("sequence")? and @get("sequence")["data"]?
      if @get("compare_for")?
        offset = @selector.get_end_time() - @selector.get_compare_end_time()
        [Analytics.Utils.parseUTCDate(item[0], offset), item[1]] for item in @get("sequence")["data"]
      else
        [Analytics.Utils.parseUTCDate(item[0], 0), item[1]] for item in @get("sequence")["data"]