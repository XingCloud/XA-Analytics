class Analytics.Collections.DimensionCharts extends Analytics.Collections.BaseCharts
  model: Analytics.Models.DimensionChart

  initialize: (models, options) ->
    _.bindAll this, "fetch_charts"
    @selector = options.selector
    @filters = options.filters
    @for_widget = (if options.for_widget? then options.for_widget else false)
    @total = 0
    @pagesize = 10
    @index = 0
    @order = 'DESC'
    @data = []
    @last_request = {params: "", resp: "", success: true, time: 0}

  initialize_charts: (metric_ids, segment_ids = []) ->
    @reset()
    @metric_ids = metric_ids
    @segment_ids = segment_ids
    @segment_id = (if @segment_ids? and @segment_ids.length > 0 then @segment_ids[0])
    @query = null
    @index = 0
    @total = 0
    @data = []
    for metric_id in metric_ids
      chart = new Analytics.Models.DimensionChart({
        id: 'm'+metric_id
        metric_id: metric_id
      })
      chart.selector = @selector
      @add(chart)

  fetch_params: () ->
    charts = []
    @each((chart) ->
      charts.push(chart.fetch_params())
    )
    request = {
      params: JSON.stringify(charts)
      index: @index
      pagesize: @pagesize
      order: @order
    }
    if @orderby?
      request["orderby"] = @orderby
    if @query?
      request["filter"] = @query

    {
      request: request
      request_id: @selector.id
    }

  fetch_url: () ->
    "/projects/" + Instances.Models.project.id + "/dimensions"

  has_pendings: () ->
    has = false
    _.each(@data, (data) ->
      if not has and data[0] == "pending"
        has = true
      _.each(data[1], (v,k) ->
        if v == "pending"
          has = true
      )
    )
#    console.log @xa_id() + " has_pendings "+has
    has

  process_fetched_data: (resp) ->
    if resp["data"]? and resp["data"]["datas"]?
      @data = resp["data"]["datas"]
    else
      @data = []
    if resp["data"]? and resp["data"]["total"]?
      @total = resp["data"]["total"]
    true