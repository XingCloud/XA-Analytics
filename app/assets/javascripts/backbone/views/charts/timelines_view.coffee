Analytics.Views.Charts ||= {}

class Analytics.Views.Charts.TimelinesView extends Backbone.View
  template: JST["backbone/templates/charts/timeline"]

  initialize: (options) ->
    _.bindAll this, "render", "redraw", "change"
    @render_to = options.render_to
    @bind_nav_toggle()
    @collection.bind "change", @change

  bind_nav_toggle: () ->
    timelines_view = this
    $('#main-container').on("resize", () ->
      timelines_view.redraw()
    )

  render: () ->
    @set_small_width()
    @highcharts = new Highcharts.Chart(@collection.charts_options(@render_to))
    @render_data()

  redraw: (options = {}) ->
    if @highcharts?
      @highcharts.destroy()
    if options.render_to?
      @render_to = options.render_to
    @render()
    @delegateEvents(@events)

  render_data: () ->
    highcharts = @highcharts
    chart_type = (if @collection.selector.get("chart_type")? then @collection.selector.get("chart_type") else "line")
    @collection.each((timeline) ->
      highcharts.get(timeline.id).timeline = timeline
      highcharts.get(timeline.id).setData(timeline.plot_data(chart_type))
    )

  change: () ->
    @render_data()
    if @collection.has_pendings()
      @highcharts.showLoading(@template())
    else
      @highcharts.hideLoading()

  set_small_width: () ->
    if not @small_width? or $(@render_to).width() < @small_width
      @small_width = $(@render_to).width()

  block: () ->
    $(@render_to).block({message: "<strong>" + I18n.t('commons.pending') + "</strong>"})

  unblock: () ->
    if $(@render_to).find(".blockOverlay").length > 0
      $(@render_to).unblock()