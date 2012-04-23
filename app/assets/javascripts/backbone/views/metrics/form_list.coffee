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
    attr = _.clone(@model.attributes)
    attr.index = @model.index
    $(@el).html(@template(attr))
    this

  delete: () ->
    $(@el).remove()

  show: () ->
    @model.list_view = this
    @model.fetch({success: (model, resp) ->
      new Analytics.Views.Metrics.FormView({
        model: model,
        id: "edit_metric_"+model.id
      }).render()
    })
