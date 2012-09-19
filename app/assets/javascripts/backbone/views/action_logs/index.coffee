Analytics.Views.ActionLogs ||= {}
class Analytics.Views.ActionLogs.IndexView extends Backbone.View
  template: JST["backbone/templates/action_logs/index"]

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @collection.bind "all", @redraw

  redraw: () ->
    @render()
    @delegateEvents(@events)

  render: () ->
    $(@el).html(@template({collection: @collection}))
    this