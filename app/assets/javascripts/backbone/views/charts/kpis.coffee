Analytics.Views.Charts ||= {}

###
collection: Analytics.Collections.TimelineCharts
###

class Analytics.Views.Charts.KpisView extends Backbone.View
  template: JST["backbone/templates/charts/kpis"]
  className: "kpis"
  events:
    "click .kpi-info" : "click_kpi_info"
    "click .segment-name" : "click_segment_name"
    "mouseenter .metric-name" : "tryshow_desc_icon"
    "mouseleave .metric-name" : "tryhide_desc_icon"
    "click a.download-table" : "download_table"
    "mouseenter" : "mouseenter_table"
    "mouseleave" : "mouseleave_table"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @timelines_view = options.timelines_view
    @render_to = options.render_to
    @collection.on("change", @redraw)

  render: () ->
    console.log "kpi render"
    $(@el).html(@template(@collection))
    $(@render_to).html(@el)
    $(@el).find("span.metric-name-desc").popover({
      html: false
      trigger: "hover"
      placement: "top"
    })


  redraw: (options = {}) ->
    @remove()
    if options.render_to?
      @render_to = options.render_to
    @render()
    @delegateEvents(@events)

  click_metric_name: (ev) ->
    if @timelines_view?
      metric_id = $(ev.currentTarget).attr("value")
      for element in $(@el).find(".kpi-info[metric-id='"+metric_id+"']")
        @toggle_kpi(element)

  click_segment_name: (ev) ->
    if @timelines_view?
      segment_id = $(ev.currentTarget).attr("value")
      for element in $(@el).find(".kpi-info[segment-id='"+segment_id+"']")
        @toggle_kpi(element)

  click_kpi_info: (ev) ->
    if @timelines_view?
      @toggle_kpi(ev.currentTarget)

  toggle_kpi: (element) ->
    kpi_id = $(element).attr('kpi-id')
    compare_kpi_id = $(element).attr('compare-kpi-id')
    if($(element).hasClass('deactive'))
      @timelines_view.highcharts.get(kpi_id).show()
      if compare_kpi_id? and compare_kpi_id.length > 0
        @timelines_view.highcharts.get(compare_kpi_id).show()
      $(element).removeClass('deactive')
    else
      @timelines_view.highcharts.get(kpi_id).hide()
      if compare_kpi_id? and compare_kpi_id.length > 0
        @timelines_view.highcharts.get(compare_kpi_id).hide()
      $(element).addClass('deactive')

  tryshow_desc_icon: (event) ->
    $("i", event.currentTarget).fadeTo('fast', 1)

  tryhide_desc_icon: (event) ->
    $("i", event.currentTarget).fadeTo('fast', 0.4)


  download_table: (event) ->
    csv = $(@el).find("table").table2CSV({delivery:'value'})
    event.currentTarget.href = 'data:text/csv;charset=UTF-8,'+encodeURIComponent(Analytics.Utils.formatCSVOutput(csv))

  mouseenter_table: (event) ->
    $(@el).find("a.download-table").show()

  mouseleave_table: (event)->
    $(@el).find("a.download-table").hide()