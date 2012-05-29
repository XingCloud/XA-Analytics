Analytics.Views.Charts ||= {}

class Analytics.Views.Charts.DimensionsView extends Backbone.View
  template: JST["backbone/templates/charts/dimensions"]

  initialize: (options) ->
    _.bindAll this, "render"
    @render_to = options.render_to

  render: () ->
    $(@el).html(@template(@collection))
    $(@render_to).html(@el)

  redraw: (options = {}) ->
    @remove()
    if options.render_to
      @render_to = options.render_to
    @render()
    @delegateEvents(@events)

