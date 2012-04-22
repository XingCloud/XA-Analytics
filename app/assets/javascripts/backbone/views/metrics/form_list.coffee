Analytics.Views.Metrics ||= {}

class Analytics.Views.Metrics.FormListView extends Backbone.View
  template: JST['backbone/templates/metrics/form-list']
  tagName: 'div'
  className: 'metric_box'
  events:
    "click img.del" : "delete"
    "click .metric_display" : "show"

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    $(@el).html(@template(@model.attributes))
    this

  delete: () ->
    $(@el).remove()
    @model.collection.remove(@model)

  show: () ->
    @model.fetch({success: (model, resp) ->
      new Analytics.Views.Metrics.FormView({
        model: model,
        id: "edit_metric_"+model.id
      }).render()
    })
