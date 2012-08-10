Analytics.Views.Metrics ||= {}

class Analytics.Views.Metrics.FormListItemView extends Backbone.View
  template: JST['backbone/templates/metrics/form-list-item']
  tagName: 'div'
  className: 'metric-box'
  events:
    "click .metric-remove" : "delete"
    "click .metric-display" : "show"

  initialize: (options) ->
    _.bindAll(this, "render")
    @parent_view = options.parent_view

  render: () ->
    attr = _.clone(@model.attributes)
    attr.index = @model.index
    $(@el).html(@template(attr))
    this

  delete: () ->
    $(@el).remove()
    @parent_view.metric_ids[@model.id] = false

  show: () ->
    @model.list_item_view = this
    if project? and not @model.get("project_id")?
      template_model = new Analytics.Models.Metric(@model.attributes)
      metrics_router.templates.remove(@model)
      metrics_router.templates.add(template_model)
      @model.collection = metrics_router.metrics
      @model.set({id: null, project_id: project.id}, {silent: true})
      if @model.get("combine_attributes")?
        @model.get("combine_attributes")["id"] = null
        @model.get("combine_attributes")["project_id"] = project.id
    new Analytics.Views.Metrics.FormView({
      model: @model
      clone: template_model
      id: (if @model.id? then "edit_metric_"+@model.id else "clone_metric")
    }).render()


class Analytics.Views.Metrics.FormListView extends Backbone.View
  template: JST['backbone/templates/metrics/form-list']
  className: 'control-group'

  initialize: () ->
    _.bindAll(this, "render")
    @metric_ids = {}

  render: () ->
    $(@el).html(@template(@model))
    for metric_id in @model.metric_ids
      @render_metric(metric_id)
    @render_metrics_dropdown()
    this

  render_metric: (metric_id) ->
    if @metric_ids[metric_id]? and @metric_ids[metric_id]
      alert("不能重复添加相同指标")
    else
      @metric_ids[metric_id] = true
      metric = metrics_router.get(metric_id)
      metric.index = @model.index
      metric_view = new Analytics.Views.Metrics.FormListItemView({model: metric, parent_view: this})
      $(@el).find('#report_tab_'+@model.index+'_metric_list').append(metric_view.render().el)

  render_metrics_dropdown: () ->
    @metrics_dropdown_view = new Analytics.Views.Metrics.IndexDropdownView({
      model: @model
      list_view: this
    })
    @metrics_dropdown_view.render()
    $(@el).find(".metric-add-dropdown").append(@metrics_dropdown_view.el)