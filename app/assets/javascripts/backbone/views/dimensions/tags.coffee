Analytics.Views.Dimensions ||= {}

class Analytics.Views.Dimensions.TagsView extends Backbone.View
  template: JST["backbone/templates/dimensions/tags"]

  initialize: (options) ->
    _.bindAll this, "render"

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    this

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)
    this