Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.FormHeaderView extends Backbone.View
  template: JST["backbone/templates/report_tabs/form-header"]
  tagName: "li"
  events:
    "click i.close" : "close"

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.index = @model.index
    $(@el).html(@template(attributes))
    this

  close: (ev) ->
    @report_form.close_tab(this)


class Analytics.Views.ReportTabs.FormBodyView extends Backbone.View
  template: JST["backbone/templates/report_tabs/form-body"]
  events:
    "click button.type-btn" : "change_chart_type"
    "click .metrics .action-add" : "new_metric"
    "click a#toggle-advanced-options" : "toggle_advanced_options"
    "click button.interval" : "change_interval"
    "change input#compare-checkbox" : "change_compare"

  initialize: () ->
    _.bindAll this, "render", "render_metrics"
    @metrics = new Analytics.Collections.Metrics(@model.get("metrics"))
    @metrics.bind "reset", @render_metrics

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.index = @model.index
    $(@el).html(@template(attributes))
    for metric in @metrics.models
      @render_metric(metric)
    this

  render_metrics: () ->
    $(@el).find('#report_tab_'+@model.index+'_metric_list').empty()
    for metric in @metrics.models
      @render_metric(metric)

  render_metric: (metric) ->
    metric.index = @model.index
    metric_view = new Analytics.Views.Metrics.FormListView({model: metric})
    $(@el).find('#report_tab_'+@model.index+'_metric_list').append(metric_view.render().el)


  new_metric: () ->
    metric = new Analytics.Models.Metric({project_id : @model.get("project_id")})
    metric.collection = @metrics
    new Analytics.Views.Metrics.FormView({
      model: metric,
      id: "new_metric"
    }).render()

  change_chart_type: (ev) ->
    $(@el).find('button.type-btn').removeClass('active')
    $(ev.currentTarget).addClass('active')
    $('#report_tabs_attributes_'+@model.index+'_chart_type').val($(ev.currentTarget).attr("value"))

  toggle_advanced_options: () ->
    $(@el).find('#advanced-options').toggle()

  change_interval: (ev) ->
    $(@el).find("button.interval").removeClass('active')
    $(ev.currentTarget).addClass('active')
    $('#report_tabs_attributes_'+@model.index+'_interval').val($(ev.currentTarget).attr("value"))

  change_compare: (ev) ->
    if $(ev.currentTarget)[0].checked
      $('#report_tabs_attributes_'+@model.index+'_compare').val(1)
    else
      $('#report_tabs_attributes_'+@model.index+'_compare').val(0)