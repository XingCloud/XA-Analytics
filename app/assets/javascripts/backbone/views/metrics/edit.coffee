Analytics.Views.Metrics ||= {}

class Analytics.Views.Metrics.EditView extends Backbone.View
  template: JST['backbone/templates/metrics/edit_index']
  tagName: 'div'
  className: 'metric_box'
  events:
    "click img.del" : "delete"

  initialize: () ->
    _.bindAll(this, "render")
    @model.bind "change", @render
    @model.view = this

  render: () ->
    $(@el).html(@template({model : @model}))
    this

  delete: () ->
    $(@el).remove()
    @model.destroy()
