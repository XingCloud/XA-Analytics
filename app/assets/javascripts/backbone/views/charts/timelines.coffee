Analytics.Views.Charts ||= {}


###
collection: Analytics.Collections.TimelineCharts([], {
  selector: @model
  filters: @model.dimensions_filters
})
render_to: $(@el).find("#report_tab_" + @model.id + "_timelines")[0]
###
class Analytics.Views.Charts.TimelinesView extends Backbone.View
  template: JST["backbone/templates/charts/timeline"]

  initialize: (options) ->
    _.bindAll this, "render"
    @render_to = options.render_to
    @bind_nav_toggle()

  bind_nav_toggle: () ->
    timelines_view = this
    small_width = @small_width
    $('#main-container').on("resize", () ->
      visibles = {}
      _.each(timelines_view.highcharts.series, (serie) ->
        visibles[serie.options.id] = serie.visible
      )
      timelines_view.redraw({visibles: visibles})
    )

  render: (visibles = {}) ->
    @set_small_width()
    @highcharts = new Highcharts.Chart(@collection.charts_options(@render_to, visibles))
    @render_data()

  redraw: (options = {}) ->
    if @highcharts?
      @highcharts.destroy()
    if options.render_to?
      @render_to = options.render_to
    @render(options.visibles)
    @delegateEvents(@events)

  render_data: () ->
    highcharts = @highcharts
    @collection.each((timeline) ->
      highcharts.get(timeline.id).timeline = timeline
      highcharts.get(timeline.id).setData(timeline.data())
    )

  set_small_width: () ->
    if not @small_width? or $(@render_to).width() < @small_width
      @small_width = $(@render_to).width()