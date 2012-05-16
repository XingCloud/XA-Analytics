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
      type: "get"
      data: @fetch_params()
      success: (if options? then options.success else @fetch_success)
      error: (if options then options.error else @fetch_error)
    })

  fetch_success: (resp) ->
    if resp.status == 200 and resp.id == project.active_tab.id
      project.active_tab.view.dimensions_sequence.set(resp.data)
      project.active_tab.view.fetch_complete()
    else if resp.id == project.active_tab.id
      project.active_tab.view.fetch_complete()

  fetch_error: (xhr, options, error) ->
    project.active_tab.view.fetch_complete()
    Analytics.Request.error(xhr, options, error)

  fetch_url: () ->
    "/projects/"+project.id+"/reports/"+@report_tab.get("report_id")+"/report_tabs/"+@report_tab.id+"/dimensions"

  fetch_params: () ->
    params = {
      end_time: parseInt(@report_tab.end_time/1000)
      length: @report_tab.get("length")
      interval: @report_tab.get("interval").toUpperCase()
      dimension: @get("dimension")
      index: @get("index")
      pagesize: @get("pagesize")
      filters: @get("filters")
      order: @get("order")
    }
    if @get("orderby")?
      params["orderby"] = @get("orderby")
    if @get("query")? and @get("query").length > 0
      params["query"] = @get("query")
    if @get("segment_id")?
      params["segment_id"] = @get("segment_id")
    params