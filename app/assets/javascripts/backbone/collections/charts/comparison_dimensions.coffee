class Analytics.Collections.ComparisonDimensionCharts extends Analytics.Collections.BaseCharts
  model: Analytics.Models.ComparisonDimensionChart

  initialize: (models, options) ->
    _.bindAll this, "fetch_charts"
    @dimension_charts = options.dimension_charts
    @selector = options.selector
    @metric_id = options.metric_id
    @last_request = {params: "", resp: "", success: true, time: 0}
    @bind "change", @trigger_change

  initialize_charts: (dimension_results, segment_id = null) ->
    @reset()
    for dimension_result in dimension_results
      chart = new Analytics.Models.ComparisonDimensionChart({
        id: @id_wrapper(dimension_result)
        dimension_result: dimension_result.toString()
        metric_id: @metric_id
        segment_id: segment_id
      })
      chart.report_tab = @selector
      @add(chart)

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
    contains_error = false
    for sequence in resp["data"]
      if not sequence.data? or sequence.data.length == 0
        contains_error = true
      chart = @get(sequence.id)
      chart.get("sequence").natural = sequence.natural
      chart.get("sequence").total = sequence.total
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
    has

  trigger_change: () ->
    @dimension_charts.trigger "change"

  get_by_dimension: (dimension) ->
    @get(@id_wrapper(dimension))


  id_wrapper: (dimension) ->
    dimension = dimension.toString()
    if not dimension? or dimension.length == 0
      Base64.encode(" ")
    else
      Base64.encode(dimension)
