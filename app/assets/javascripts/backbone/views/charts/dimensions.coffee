Analytics.Views.Charts ||= {}

###
collection: charts (DimensionCharts)
render_to: render_to
###
class Analytics.Views.Charts.DimensionsView extends Backbone.View
  template: JST["backbone/templates/charts/dimensions"]

  events:
    "mouseenter .dimensions-table" : "mouseenter_table"
    "mouseleave .dimensions-table" : "mouseleave_table"
    
  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @render_to = options.render_to
    @collection.on "change", @redraw


  render: () ->
    $(@el).html(@template(@collection))
    $(@render_to).html(@el)

  redraw: (options = {}) ->
    @remove()
    if options.render_to
      @render_to = options.render_to
    @render()
    @delegateEvents(@events)

  mouseenter_table: (event) ->
    $(@el).find("a.download-table").show()

  mouseleave_table: (event)->
    $(@el).find("a.download-table").hide()