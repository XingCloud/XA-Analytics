
###

代表报告中的曲线的值

from Analytics.Views.Widgets.ShowView:
  selector: Analytics.Models.Widget
  for_widget: true
from Analytics.Views.ReportTabs.ShowView:
  selector: Analytics.Models.ReportTab
  filters: Analytics.Models.ReportTab.dimensions_filters
###
class Analytics.Collections.TimelineCharts extends Analytics.Collections.BaseCharts
  model: Analytics.Models.TimelineChart

  initialize: (models, options) ->
    _.bindAll this, "fetch_charts"
    #todo immars how selector works?
    @project = Instances.Models.project
    @selector = options.selector
    @filters = options.filters
    @for_widget = (if options.for_widget? then options.for_widget else false)
    @last_request = {params: "", resp: "", success: true, time: 0}
    @activate()

  initialize_charts: (metric_ids, segment_ids = [0], has_compare = false) ->
    segment_ids = (if segment_ids.length == 0 then [0] else segment_ids)
    @metric_ids = metric_ids
    @segment_ids = segment_ids
    @has_compare = has_compare
    index = 0
    charts = []
    for metric_id in metric_ids
      for segment_id in segment_ids
        chart_id = @generate_chart_id(metric_id, segment_id, false)
        if has_compare? and has_compare
          compare_chart_id = @generate_chart_id(metric_id, segment_id, true)
          charts.push(@initialize_chart(compare_chart_id, metric_id, segment_id, null, chart_id, index))
        charts.push(@initialize_chart(chart_id, metric_id, segment_id, compare_chart_id, null, index))
        index = index + 1
    @reset()
    for chart in charts
      if not @get(chart.id)
        @add(chart)
    if metric_ids.length > 0
      @initialize_display(metric_ids[0])

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
    if @get(chart.id)?
      chart.display = @get(chart.id).display
    chart

  initialize_display: (metric_id) ->
    if @filter((chart) -> chart.display).length == 0
      @each((chart) ->
        if chart.get("metric_id") == metric_id
          chart.display = true
      )

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
    "/projects/" + Instances.Models.project.id + "/timelines"

  process_fetched_data: (resp) ->
    if not resp["data"]? or resp["err_code"]?
      false
    else
      contains_error = false
      for sequence in resp["data"]
        if not sequence.data? or sequence.data.length == 0
          contains_error = true
        chart = @get(sequence.id)
        _.extend(chart.get("sequence"), sequence)

      not contains_error
  
  has_pendings: () ->
    has = false
    @each((chart) ->
      if chart.get("sequence")?.natural == "pending"
        has = true
      if chart.get("sequence")?.total == "pending"
        has = true
      if (not has) and _.find(chart.data(), (point) -> point[1] == "pending")
        has = true
    )
#     @xa_id() + " has_pendings "+has
    has

  charts_options: (render_to) ->
    interval_count = Analytics.Utils.intervalCount(@selector.get_end_time(), @selector.get("interval"), @selector.get("length"))
    chart_type = (if @selector.get("chart_type")? then @selector.get("chart_type") else 'line')
    options = {
      credits:
        enabled: false
      title:
        text: ""
      chart:
        renderTo: render_to
        height: 220 + 6 * (if @models.length > 9 then @models.length - 9 else 0)
        type: chart_type
      yAxis:
        min: 0
        gridLineWidth: 0.5
        showFirstLabel: false
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
      loading:
        style:
          "background-color": "transparent"
          opacity: 1
      plotOptions:
        series:
          fillOpacity:0.1
          marker:
            enabled: interval_count <= (if @for_widget? then 24 else 48)          
      series: []
    }
    if @selector.get("interval") == "min5" or @selector.get("interval") == "hour"
      options.xAxis.labels.formatter = () -> Highcharts.dateFormat('%m/%d %H:%M', this.value)
    else
      options.xAxis.labels.formatter = () -> Highcharts.dateFormat('%m/%d', this.value)
    @each((chart) ->
      options.series.push({
        name: chart.name()
        #data: chart.plot_data()
        color: "#" + chart.get("color")
        id: chart.id
        visible: chart.display
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

  charts_map: () ->
    cmap = {}
    @each((chart) ->
      sequence = chart.get("sequence")["data"]
      for item in sequence
        if not cmap[chart.get("segment_id")]?
          cmap[chart.get("segment_id")] = {}
        if not cmap[chart.get("segment_id")][item[0]]?
          cmap[chart.get("segment_id")][item[0]] = {}
        cmap[chart.get("segment_id")][item[0]][chart.get("metric_id")] = item[1]
    )
    cmap
