Analytics.Views.Metrics ||= {}

#model: Analytics.Models.Metric
class Analytics.Views.Metrics.FormListItemView extends Backbone.View

  template: JST['backbone/templates/metrics/form-list-item']
  tagName: 'div'
  className: 'metric-box'
  events:
    "click .metric-remove" : "delete"
    "click .metric-display" : "show"
    "click .metric-copy" : "copy"
    "click .metric-moveup" : "moveup"
    "click .metric-movedown" : "movedown"

  initialize: (options) ->
    _.bindAll(this, "render")
    @parent_view = options.parent_view

  render: () ->
    attr = _.clone(@model.attributes)
    attr.index = @model.index
    $(@el).html(@template(attr))
    this

  delete: () ->
    $(".tooltip").remove()
    $(@el).remove()
    metric_ids = @parent_view.model.metric_ids
    metric_ids.splice(metric_ids.indexOf(@model.id),1)


  show: () ->
    @model.list_item_view = this
    if Instances.Models.project? and not @model.get("project_id")?
      template_model = new Analytics.Models.Metric(@model.attributes)
      Instances.Collections.metrics.remove(@model)
      Instances.Collections.metrics.add(template_model)
      @model.collection = Instances.Collections.metrics
      @model.set({id: null, project_id: Instances.Models.project.id}, {silent: true})
      if @model.get("combine_attributes")?
        @model.get("combine_attributes")["id"] = null
        @model.get("combine_attributes")["project_id"] = Instances.Models.project.id
    new Analytics.Views.Metrics.FormView({
      model: @model
      clone: template_model
      id: (if @model.id? then "edit_metric_"+@model.id else "clone_metric")
    }).render()

  copy: () ->
    cloned = @model.clone()
    cloned.set({id: null, project_id: if Instances.Models.project then Instances.Models.project.id else null})
    cloned.collection = Instances.Collections.metrics
    if cloned.get("combine_attributes")?
      cloned.get("combine_attributes")["id"] = null
      cloned.get("combine_attributes")["project_id"] = Instances.Models.project.id
      cloned.get("combine_attributes")["combine_attributes"] = {}
    else
      cloned.set("combine_attributes", {})
    cloned.set({"name": cloned.get("name")+"_copy"})

    cloned.list_view = @parent_view

    cloned.save({}, {
      wait: true,
      success: (model, resp) ->
        model.collection.add(model)
        model.list_view.render_metric(model.id)
      error: (xhr, options, error) ->
        $("body").prepend(JST['backbone/templates/utils/error']({status: 500}))
    })

  moveup: () ->
    $(".tooltip").remove()
    cur_id = parseInt($(@el).find("input.metric-id").val())
    old_ids = @parent_view.model.metric_ids
    for id, i in old_ids
      if id == cur_id and i != 0
        [old_ids[i-1], old_ids[i]] = [old_ids[i], old_ids[i-1]]
        @parent_view.model.metric_ids = old_ids
        @parent_view.render()
        return

  movedown: () ->
    $(".tooltip").remove()
    cur_id = parseInt($(@el).find("input.metric-id").val())
    old_ids = @parent_view.model.metric_ids
    for id, i in old_ids
      if id == cur_id and i != old_ids.length - 1
        [old_ids[i+1], old_ids[i]] = [old_ids[i], old_ids[i+1]]
        @parent_view.model.metric_ids = old_ids
        @parent_view.render()
        return
###

  movedown: () ->
    cur_id = $(@el).find("input.metric-id").val()
    metrics = $(@parent_view.el).find(".metric-box-group .metric-box")
    for metric, i in metrics
      metric = $(metric)
      if metric.find("input.metric-id").val() == cur_id
        if i != metrics.length-1
          target = $(metrics[i+1])
          metric.remove()
          target.after(metric)
          return
###

###
model: {
  index: Analytics.Models.ReportTab.index
  metric_ids: Analytics.Models.ReportTab.get("metric_ids")
  project_id: Analytics.Models.ReportTab.get("project_id")
}
###
class Analytics.Views.Metrics.FormListView extends Backbone.View
  template: JST['backbone/templates/metrics/form-list']
  className: 'control-group'

  initialize: () ->
    _.bindAll(this, "render")
    #已经渲染过的metric的id记录。
    #如果已经添加，随后又删掉，则@metric_ids[id] = false

  render: () ->
    $(@el).html(@template(@model))
    for metric_id in @model.metric_ids
      @render_metric(metric_id)
    $(@el).find(".metric-remove").tooltip({title: I18n.t('commons.delete')})
    $(@el).find(".metric-copy").tooltip({title: I18n.t('commons.copy')})
    $(@el).find(".metric-moveup").tooltip({title: I18n.t('commons.up')})
    $(@el).find(".metric-movedown").tooltip({title: I18n.t('commons.down')})
    @render_metrics_dropdown()
    this

  add_metric: (metric_id) ->
    if @model.metric_ids.indexOf(metric_id)>=0
      alert(I18n.t('views.metrics.form_list.alert'))
    else
      @model.metric_ids.push(metric_id)
      @render_metric(metric_id)

  render_metric: (metric_id) ->
    metric = Instances.Collections.metrics.get(metric_id)
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