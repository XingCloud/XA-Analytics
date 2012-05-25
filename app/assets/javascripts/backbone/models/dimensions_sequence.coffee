class Analytics.Models.DimensionsSequence extends Backbone.Model
  defaults:
    total: 0
    pagesize: 10
    index: 0
    orderby: null
    order: "DESC"
    dimension: null
    query: null
    segment_id: null

  initialize: (options) ->
    @set({
      data: []
      dimension: (if options.dimensions? and options.dimensions.length > 0 then options.dimensions[0])
      segment_ids: []
    })

  init: () ->
    segment_ids = segments_router.segments.selected().concat(segments_router.templates.selected())
    @set({
      data: []
      total: 0
      index: 0
      query: null
      segment_ids: segment_ids
      segment_id: (if segment_ids.length > 0 then segment_ids[0] else null)
    }, {silent: true})

  fetch_data: (options) ->
    $.ajax({
      url: @fetch_url()
      dataType: "json"
      type: "post"
      data: @fetch_params()
      success: (if options? then options.success else @fetch_success)
      error: (if options then options.error else @fetch_error)
    })

  fetch_success: (resp) ->
    if resp.id.toString() == project.active_tab.id.toString()
      project.active_tab.view.dimensions_sequence.set(resp.data)
      project.active_tab.view.fetch_complete()

  fetch_error: (xhr, options, error) ->
    project.active_tab.view.fetch_complete()
    Analytics.Request.error(xhr, options, error)

  fetch_url: () ->
    "/projects/"+project.id+"/dimensions"

  fetch_params: () ->
    options = {
      params: @options()
      index: @get("index")
      pagesize: @get("pagesize")
      order: @get("order")
      id: @report_tab.id
    }
    if @get("orderby")?
      options["orderby"] = @get("orderby")
    if @get("query")?
      options["filter"] = @get("query")
    options

  options: () ->
    options = []
    for metric_attributes in @get("metrics")
      metric_options = {
        id: metric_attributes.id
        end_time: Analytics.Utils.formatUTCDate(@report_tab.end_time, "yyyy-MM-dd")
        start_time: Analytics.Utils.formatUTCDate(@report_tab.end_time - (@report_tab.get("length") - 1)*86400000, "yyyy-MM-dd")
        interval: @report_tab.get("interval").toUpperCase()
        groupby: @get("dimension").value
        groupby_type: @get("dimension").dimension_type.toUpperCase()
      }
      metric = metrics_router.get(metric_attributes.id)
      _.extend(metric_options, metric.sequence_options(@get("segment_id"), @get("filters")))
      options.push(metric_options)
    JSON.stringify(options)
