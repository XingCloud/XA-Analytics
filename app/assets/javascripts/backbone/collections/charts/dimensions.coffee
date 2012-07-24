class Analytics.Collections.DimensionCharts extends Backbone.Collection
  model: Analytics.Models.DimensionChart

  initialize: (models, options) ->
    @selector = options.selector
    @filters = options.filters
    @for_widget = (if options.for_widget? then options.for_widget else false)
    @total = 0
    @pagesize = 10
    @index = 0
    @order = 'DESC'
    @data = []

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
    "/projects/" + project.id + "/dimensions"

  fetch_charts: (options = {}) ->
    collection = this
    start_time = (new Date()).getTime()
    Analytics.Request.post({
      url: @fetch_url()
      data: @fetch_params()
      success: (resp) ->
        collection.fetch_success(resp, start_time)
        if options.success?
          options.success(resp)
      error: (xhr, opts, err) ->
        collection.fetch_error(xhr, opts, err, start_time)
        if options.error?
          options.error(xhr, opts, err)
    }, true)

  fetch_success: (resp, start_time) ->
    if resp["data"]? and resp["data"]["datas"]?
      @data = resp["data"]["datas"]
    if resp["data"]? and resp["data"]["total"]?
      @total = resp["data"]["total"]
    @xa_action(start_time, "success")

  fetch_error: (xhr, opts, err, start_time) ->
    @xa_action(start_time, "error")

  xa_action: (start_time, tag) ->
    xa_action = "response." + project.get("identifier") + "." + @xa_id()
    xa_interval = (new Date()).getTime() - start_time
    XA.action(xa_action + ".responsetime." + Analytics.Utils.timeShard(xa_interval) + "," + xa_interval, xa_action+"."+tag+",0")

  xa_id: () ->
    if @for_widget
      "widget." + @selector.id
    else
      "report." + @selector.get("report_id") + "/" + @selector.id + "/t"
