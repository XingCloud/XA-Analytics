class Analytics.Models.DimensionsSequence extends Backbone.Model
  defaults:
    total: 0
    pagesize: 10
    index: 0
    orderby: null
    order: "DESC"
    dimension: null

  initialize: (options) ->
    @set({
      data: []
      dimension: (if options.dimensions? and options.dimensions.length > 0 then options.dimensions[0])
    })

  init: () ->
    @set({
      data: []
      total: 0
      index: 0
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

  fetch_error: (resp) ->
    project.active_tab.view.fetch_complete()

  fetch_url: () ->
    "/projects/"+project.id+"/reports/"+@report_tab.get("report_id")+"/report_tabs/"+@report_tab.id+"/dimensions"

  fetch_params: () ->
    {
      end_time: parseInt(project.report_end_time/1000)
      length: @report_tab.get("length")
      interval: @report_tab.get("interval").toUpperCase()
      dimension: @get("dimension")
      index: @get("index")
      pagesize: @get("pagesize")
      filters: @get("filters")
      order: @get("order")
      orderby: @get("orderby")
    }