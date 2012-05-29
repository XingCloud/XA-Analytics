class Analytics.Collections.TimelineCharts extends Backbone.Collection
  model: Analytics.Models.TimelineChart

  initialize: (models, options) ->
    @selector = options.selector
    @filters = options.filters
    @for_widget = (if options.for_widget? then options.for_widget else false)

  initialize_charts: (metric_ids, segment_ids = [0], has_compare = false) ->
    @reset()
    segment_ids = (if segment_ids.length == 0 then [0] else segment_ids)
    @display_metric = (if metric_ids.length > 0 then metric_ids[0])
    @metric_ids = metric_ids
    @segment_ids = segment_ids
    @has_compare = has_compare
    index = 0
    for metric_id in metric_ids
      metric = metrics_router.get(metric_id)
      for segment_id in segment_ids
        chart_id = @generate_chart_id(metric_id, segment_id, false)
        if has_compare? and has_compare
          compare_chart_id = @generate_chart_id(metric_id, segment_id, true)
          @initialize_chart(compare_chart_id, metric_id, segment_id, null, chart_id, index)
        @initialize_chart(chart_id, metric_id, segment_id, compare_chart_id, null, index)
        index = index + 1

  initialize_chart: (chart_id, metric_id, segment_id, compare_to, compare_for, index) ->
    chart = @get(chart_id)
    chart = new Analytics.Models.TimelineChart({
      id: chart_id
      metric_id: metric_id
      segment_id: segment_id
      compare_to: compare_to
      compare_for: compare_for
      color: Analytics.Utils.getColor(index, compare_for?)
      filters: @filters
    })
    chart.selector = @selector
    @add(chart)

  generate_chart_id: (metric_id, segment_id, for_compare) ->
    "m" + metric_id + "s" + segment_id + (if for_compare then 'c' else '')

  fetch_params: () ->
    params = []
    @each((chart) -> params.push(chart.fetch_params()))
    {
      request: {params: JSON.stringify(params)}
      request_id: @selector.id
    }

  fetch_url: () ->
    "/projects/" + project.id + "/timelines"

  fetch_charts: (options) ->
    collection = this
    fetch_success = (resp) ->
      for sequence in resp["data"]
        chart = collection.get(sequence.id)
        _.extend(chart.get("sequence"), sequence)
      options.success(resp)
    Analytics.Request.post(@fetch_url(), @fetch_params(), fetch_success, options.error, true)

  charts_options: (render_to) ->
    interval_count = Analytics.Utils.intervalCount(@selector.get_end_time(), @selector.get("interval"), @selector.get("length"))
    options = {
      credits:
        enabled: false
      title:
        text: ""
      chart:
        renderTo: render_to
        height: 200 + 20 * (if @models.length > 9 then @models.length - 9 else 0)
        type: (if @selector.get("chart_type")? then @selector.get("chart_type") else 'line')
      yAxis:
        min: 0
        gridLineWidth: 0.5
        showFirstLabel: true
        title:
          text: ""
      xAxis:
        tickInterval: @charts_interval()
        gridLineWidth: 0
        tickWidth: 0
        showFirstLabel: true
        type: "datetime"
        labels:
          align: "center"
      tooltip:
        useHTML: true
        enabled: true
        shared: true
        formatter: () -> JST['backbone/templates/charts/tooltip'](@)
      legend:
        enabled: @for_widget
      plotOptions:
        line:
          marker:
            enabled: interval_count <= (if @for_widget? then 24 else 48)
      series: []
    }
    if @selector.get("interval") == "min5" or @selector.get("interval") == "hour"
      options.xAxis.labels.formatter = () -> Highcharts.dateFormat('%b %d %H:%M', this.value)
    else
      options.xAxis.labels.formatter = () -> Highcharts.dateFormat('%b %d', this.value)
    display_metric = @display_metric
    @each((chart) ->
      options.series.push({
        name: chart.name()
        data: chart.data()
        color: "#" + chart.get("color")
        id: chart.id
        visible: (chart.get("metric_id") == display_metric)
      })
    )
    options

  charts_interval: () ->
    if @selector.get("length") <= 7 and (@selector.get("interval") == "min5" or @selector.get("interval") == "hour")
      (if @for_widget then 43200000 else 7200000) * @selector.get("length")
    else if @selector.get("length") <= 14
      (if @for_widget then 172800000 else 86400000)
    else if @selector.get("length") <= 72
      (if @for_widget then 1209600000 else 604800000)
    else
      2419200000