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
    metric = Instances.Collections.metrics.get(@get("metric_id"))
    metric_options = metric.sequence_options(@get("segment_id"), @get("filters"))
    _.extend(metric_options, {
      id: @id
      end_time: Analytics.Utils.formatUTCDate(end_time, "YYYY-MM-DD")
      start_time: Analytics.Utils.formatUTCDate(start_time, "YYYY-MM-DD")
      interval: @selector.get("interval").toUpperCase()
      type: "COMMON"
      project_id: Instances.Models.project.get("identifier")
    })

  name: () ->
    if @get("segment_id") != 0
      Instances.Collections.metrics.get(@get("metric_id")).get("name") + "(" + Instances.Collections.segments.get(@get("segment_id")).get("name") + ")"
    else
      Instances.Collections.metrics.get(@get("metric_id")).get("name")

  data: () ->
    if @get("sequence")? and @get("sequence")["data"]?
      if @get("compare_for")?
        offset = @selector.get_end_time() - @selector.get_compare_end_time()
        [Analytics.Utils.parseUTCDate(item[0], offset), item[1]] for item in @get("sequence")["data"]
      else
        [Analytics.Utils.parseUTCDate(item[0], 0), item[1]] for item in @get("sequence")["data"]

  ##过滤pending标记，给画图用
  plot_data: (chart_type) ->  
    data = _.map(@data(), (x) -> if not x[1]? or x[1] == "pending" or x[1] == "XA-NA" then [x[0], 0] else x)

    if Instances.Collections.metrics.get(@get("metric_id")).get('value_type') == "rounding"
      _.each(data, (x, index) -> data[index][1] = Math.floor(data[index][1]))
      
    if chart_type == "area"
      _.each(data, (x, index) -> if index>0 && data[index][1]? then data[index][1] += data[index-1][1])

    data