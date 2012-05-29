Analytics.Views.Charts ||= {}

class Analytics.Views.Charts.TimelinesView extends Backbone.View
  template: JST["backbone/templates/charts/timeline"]

  initialize: (options) ->
    _.bindAll this, "render"
    @render_to = options.render_to
    @bind_nav_toggle()

  bind_nav_toggle: () ->
    timelines_view = this
    $('#main-container').on("resize", () ->
      original_width = $(timelines_view.render_to).attr("small-width")
      if $('#container td.nav-toggle').hasClass('left-nav-hide')
        timelines_view.highcharts.setSize($(timelines_view.render_to).width())
      else
        timelines_view.highcharts.setSize(original_width)
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
    @collection.each((timeline) ->
      highcharts.get(timeline.id).timeline = timeline
      highcharts.get(timeline.id).setData(timeline.data())
    )

  set_small_width: () ->
    if not $(@render_to).attr("small-width")? or $(@render_to).attr("small-width").length == 0
      $(@render_to).attr("small-width", $(@render_to).width())