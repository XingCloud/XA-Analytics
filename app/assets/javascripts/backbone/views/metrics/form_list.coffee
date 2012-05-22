Analytics.Views.Metrics ||= {}

class Analytics.Views.Metrics.FormListItemView extends Backbone.View
  template: JST['backbone/templates/metrics/form-list-item']
  tagName: 'div'
  className: 'metric-box'
  events:
    "click .metric-remove" : "delete"
    "click .metric-display" : "show"

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
    model = @model
    model.list_item_view = this
    model.edit({success: (resp) ->
      template_model = null
      if not resp.id?
        template_model = new Analytics.Models.Metric(model.attributes)
        metrics_router.templates.remove(model)
        metrics_router.templates.add(template_model)
        model.collection = metrics_router.metrics
      model.set(resp)
      new Analytics.Views.Metrics.FormView({
        model: model
        clone: template_model
        id: (if model.id? then "edit_metric_"+model.id else "clone_metric")
      }).render()
    })


class Analytics.Views.Metrics.FormListView extends Backbone.View
  template: JST['backbone/templates/metrics/form-list']
  className: 'control-group'

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    $(@el).html(@template(@model))
    for metric_id in @model.metric_ids
      @render_metric(metric_id)
    @render_metrics_dropdown()
    this

  render_metric: (metric_id) ->
    metric = metrics_router.get(metric_id)
    metric.index = @model.index
    metric_view = new Analytics.Views.Metrics.FormListItemView({model: metric})
    $(@el).find('#report_tab_'+@model.index+'_metric_list').append(metric_view.render().el)

  render_metrics_dropdown: () ->
    @metrics_dropdown_view = new Analytics.Views.Metrics.IndexDropdownView({
      model: @model
      list_view: this
    })
    @metrics_dropdown_view.render()
    $(@el).find(".metric-add-dropdown").append(@metrics_dropdown_view.el)