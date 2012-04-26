class Analytics.Models.ChartSequence extends Backbone.Model

  defaults:
    for_compare: false
    data: []
    index: 0
    natural: 0
    total: 0
    rate: 0.0
    percent: 0.0

  initialize: (options) ->
    if @get("for_compare")
      @set({color: Analytics.Utils.getColor(@get("index"), true)})
    else
      @set({color: Analytics.Utils.getColor(@get("index"), false)})

  legend: (compare) ->
    if @get("segment_id") == 0
      percent = 1
      value = @get("total")
      compare_value = (if compare? then compare.get("total") else 0)
    else
      percent = @get("percent")
      value = @get("natural")
      compare_value = (if compare? then compare.get("natural") else 0)
    {
      compare: compare?,
      percent: percent,
      id: @id,
      compare_id: (if compare? then compare.id else null),
      value: value,
      compare_value: compare_value,
      total: @get("total"),
      compare_total: (if compare? then compare.get("total") else 0),
      color: Analytics.Utils.getColor(@get("index"), false),
      compare_color: Analytics.Utils.getColor(@get("index"), true)
    }

  chart: () ->
    offset = project.report_end_time - @report_tab.compare_end_time
    if @get("segment_id") != 0
      name = metrics_router.get(@get("metric_id")).get("name") + "(" + segments_router.get(@get("segment_id")).get("name") + ")"
    else
      name = metrics_router.get(@get("metric_id")).get("name")
    if @get("for_compare")
      color = Analytics.Utils.getColor(@get("index"), true)
    else
      color = Analytics.Utils.getColor(@get("index"), false)
    {
      has_compare: @report_tab.get("compare") != 0
      for_compare: @get("for_compare"),
      offset: offset,
      id: @get("id"),
      color: color,
      name: name,
      interval: @get("interval")
    }

  chart_data: () ->
    offset = project.report_end_time - @report_tab.compare_end_time
    if @get("for_compare")
      data = ([Analytics.Utils.parseUTCDate(item[0], offset), item[1]] for item in @get("data"))
    else
      data = ([Analytics.Utils.parseUTCDate(item[0], 0), item[1]] for item in @get("data"))
    data

