class Analytics.Collections.ChartSequences extends Backbone.Collection
  model: Analytics.Models.ChartSequence

  initialize: (models, options) ->
    @report_tab = options.report_tab

  init: () ->
    @reset_sequences()
    index = 0
    for segment_id in @segment_ids()
      for metric_id in @report_tab.get("metric_ids")
        @add_sequence(metric_id, segment_id, index, false)
        if @has_compare
          @add_sequence(metric_id, segment_id, index, true)
        index = index + 1
    @chart_init()

  reset_sequences: () ->
    @reset()
    @has_compare = (if @report_tab.get("compare") != 0 then true else false)
    @all_segment = not @has_segments()

  add_sequence: (metric_id, segment_id, index, for_compare) ->
    sequence = new Analytics.Models.ChartSequence({
      id: "metric_"+metric_id+"_segment_"+segment_id+"_"+(if for_compare then 1 else 0)
      segment_id: segment_id
      metric_id: metric_id
      index: index
      for_compare: for_compare
    })
    sequence.report_tab = @report_tab
    @add(sequence)

  fetch_params: () ->
    end_time: parseInt(@report_tab.end_time/1000)
    compare_end_time: parseInt(@report_tab.compare_end_time/1000)
    length: @report_tab.get("length")
    compare: @report_tab.get("compare")
    interval: @report_tab.get("interval")
    filters: @report_tab.dimensions_filters
    segment_ids: @segment_ids()

  fetch_data: () ->
    collection = this
    $.ajax({
      url: @report_tab.data_url()
      dataType: "json"
      type: "get"
      data: @fetch_params()
      success: @fetch_success
      error: @fetch_error
    })

  fetch_success: (resp) ->
    if resp.id == project.active_tab.id
      project.active_tab.view.chart_sequences.reset(resp.data)
      project.active_tab.view.redraw_chart()
      project.active_tab.view.fetch_complete()

  fetch_error: (xhr, options, error) ->
    project.active_tab.view.fetch_complete()
    Analytics.Request.error(xhr, options, error)

  segment_ids: () ->
    segment_ids = segments_router.segments.selected().concat(segments_router.templates.selected())
    (if segment_ids.length == 0 then [0] else segment_ids)

  has_segments: () ->
    segment_ids = segments_router.segments.selected().concat(segments_router.templates.selected())
    segment_ids.length > 0

  comparator: (sequence) ->
    sequence.get("index")

  sequence: (metric_id, segment_id) ->
    @find((sequence) ->
      (sequence.get("metric_id") == metric_id and
       sequence.get("segment_id") == segment_id and
       not sequence.get("for_compare"))
    )

  compare_sequence: (sequence) ->
    @find((item) ->
      (item.get("metric_id") == sequence.get("metric_id") and
       item.get("segment_id") == sequence.get("segment_id") and
       item.get("for_compare"))
    )

  props: (prop) ->
    propset = {}
    @each((sequence) ->
      if not propset.hasOwnProperty(sequence.get(prop))
        propset[sequence.get(prop)] = true
    )
    for key of propset
      parseInt(key)

  legend: () ->
    metric_ids = @props("metric_id")
    legend = {
      segments: []
      metrics: (metrics_router.get(id).get("name") for id in metric_ids)
      has_compare: @has_compare
      all_segment: @all_segment
    }
    for segment_id in @props("segment_id")
      legend.segments.push(@legend_segment(segment_id, metric_ids))
    legend

  legend_segment: (segment_id, metric_ids) ->
    segment = {
      id: segment_id,
      name: (if not @all_segment then segments_router.get(segment_id).get("name") else ""),
      metrics: []
    }
    for metric_id in metric_ids
      metric = @legend_metric(metric_id, segment_id)
      if metric? then segment.metrics.push(metric)
    segment

  legend_metric: (metric_id, segment_id) ->
    sequence = @sequence(metric_id, segment_id)
    if sequence?
      if @has_compare
        metric = sequence.legend(@compare_sequence(sequence))
      else
        metric = sequence.legend(null)
    metric

  tick_interval: () ->
    if @report_tab.get("length") <= 7 and (@report_tab.get("interval") == "min5" or @report_tab.get("interval") == "hour")
      7200000 * @report_tab.get("length")
    else if @report_tab.get("length") <= 14
      86400000
    else if @report_tab.get("length") <= 1000 * 60 * 60 * 24 * 72
      604800000
    else
      2592000000

  chart_init: () ->
    options = @chart_options()
    if @chart?
      @chart.destroy()
    @chart = new Highcharts.Chart(options)
    chart = @chart
    @each((sequence) ->
      chart.get(sequence.id).sequence = sequence.chart()
    )

  chart_render: () ->
    chart = @chart
    report_tab = @report_tab
    @each((sequence) ->
      sequence.report_tab = report_tab
      chart.get(sequence.id).setData(sequence.chart_data())
      chart.get(sequence.id).sequence = sequence.chart()
    )

  chart_options: () ->
    interval_count = Analytics.Utils.intervalCount(@report_tab.end_time, @report_tab.get("interval"), @report_tab.get("length"))
    options = {
      credits:
        enabled: false
      title:
        text: ""
      chart:
        renderTo: "chart"
        height: 200
        type: @report_tab.get("chart_type")
      yAxis:
        min: 0
        gridLineWidth: 0.5
        showFirstLabel: true
        title:
          text: ""
      xAxis:
        tickInterval: @tick_interval()
        gridLineWidth: 0
        tickWidth: 0
        showFirstLabel: true
        type: "datetime"
        labels:
          align: "center"
      tooltip:
        enabled: true
        shared: true
        formatter: () ->
          tip = JST['backbone/templates/report_tabs/show-tooltip'](@)
          tip.replace(/[\t\n ]/g, '').replace(/%blank%/g, '  ')
      legend:
        enabled: false
      plotOptions:
        line:
          marker:
            enabled: interval_count <= 48
      series: []
    }

    if @report_tab.get("interval") == "min5" or @report_tab.get("interval") == "hour"
      options.xAxis.labels.formatter = () -> Highcharts.dateFormat('%b %d %H:%M', this.value)
    else
      options.xAxis.labels.formatter = () -> Highcharts.dateFormat('%b %d', this.value)

    @each((sequence) ->
      chart_sequence = sequence.chart()
      options.series.push({
        name: chart_sequence.name
        data: sequence.chart_data()
        color: "#"+chart_sequence.color
        id: chart_sequence.id
      })
    )

    options
