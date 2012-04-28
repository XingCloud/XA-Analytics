Analytics.Views.Metrics ||= {}

class Analytics.Views.Metrics.FormListItemView extends Backbone.View
  template: JST['backbone/templates/metrics/form-list-item']
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
    @model.list_item_view = this
    @model.fetch({success: (model, resp) ->
      new Analytics.Views.Metrics.FormView({
        model: model,
        id: "edit_metric_"+model.id
      }).render()
    })


class Analytics.Views.Metrics.FormListView extends Backbone.View
  template: JST['backbone/templates/metrics/form-list']
  className: 'control-group'

  events:
    "click .metrics .action-add" : "new_metric"

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    $(@el).html(@template(@model))
    for metric_id in @model.metric_ids
      @render_metric(metric_id)
    this

  render_metric: (metric_id) ->
    metric = metrics_router.metrics.get(metric_id)
    metric.index = @model.index
    metric_view = new Analytics.Views.Metrics.FormListItemView({model: metric})
    $(@el).find('#report_tab_'+@model.index+'_metric_list').append(metric_view.render().el)

  new_metric: (ev) ->
    metric = new Analytics.Models.Metric({project_id : @model.project_id})
    metric.list_view = this
    metric.collection = metrics_router.metrics
    new Analytics.Views.Metrics.FormView({
      model: metric,
      id: "new_metric"
    }).render()