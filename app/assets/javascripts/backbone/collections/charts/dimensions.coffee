class Analytics.Collections.DimensionCharts extends Analytics.Collections.BaseCharts
  model: Analytics.Models.DimensionChart

  initialize: (models, options) ->
    _.bindAll this, "fetch_charts"
    @project = Instances.Models.project
    @selector = options.selector
    @filters = options.filters
    @for_widget = (if options.for_widget? then options.for_widget else false)
    @total = 0
    @pagesize = 10
    @index = 0
    @order = 'DESC'
    @data = []
    @info = {}
    @status = null
    @compares = {}
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
    @info = {}
    @status = null
    @compares = {}
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
    return @status == "pending"

  process_fetched_data: (resp) ->
    if not resp["data"]? or resp["err_code"]?
      true
    else
      if resp["data"]? and resp["data"]["datas"]?
        @data = resp["data"]["datas"]
      else
        @data = []
      if resp["data"]? and resp["data"]["total"]?
        @total = resp["data"]["total"]
      if resp["data"]? and resp["data"]["info"]?
        @info = resp["data"]["info"]
      if resp["data"]?
        @status = resp["data"]["status"]

      @process_maxis_data()
      @fetch_compare_data()
      true
            
  process_maxis_data: () ->
    maxis = {}
    _.each(@data, (d) ->
      _.each(d[1], (v, metric_id) ->
        v= parseFloat(v)
        if v
          if v < 0
            maxis[metric_id] = -1
          else
            if not maxis[metric_id]?
              maxis[metric_id] = 0
            if maxis[metric_id] < v && maxis[metric_id] != -1
              maxis[metric_id] = v
      )
    )
    @maxis = maxis

  fetch_compare_data: () ->
    if (not @for_widget and @selector.get("compare") != 0 and
        @data.length > 0 and not @has_pendings() and
        @orderby?)
      dimension_results = (item[0] for item in @data)
      compare = @compares[@orderby]
      if not compare?
        compare = new Analytics.Collections.ComparisonDimensionCharts([], {
          dimension_charts: @
          selector: @selector
          metric_id: @orderby
        })
        @compares[@orderby] = compare
      compare.initialize_charts(dimension_results, @segment_id)
      compare.fetch_charts()
