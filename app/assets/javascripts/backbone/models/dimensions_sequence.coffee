class Analytics.Models.DimensionsSequence extends Backbone.Model
  defaults:
    total: 0
    pagesize: 10
    index: 0
    orderby: null
    order: "ASC"

  initialize: (options) ->
    @set({
      filters: []
      data: []
    })

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
      level: @get("filters").length
      index: @get("index")
      pagesize: @get("pagesize")
      filters: @get("filters")
    }

  reset_params: () ->
    @set({
      index: 0
      orderby: null
      order: 'ASC'
      pagesize: 10
    }, {slient: true})