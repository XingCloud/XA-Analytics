Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.FormHeaderView extends Backbone.View
  template: JST["backbone/templates/report_tabs/form-header"]
  tagName: "li"
  events:
    "click i.close" : "close"
    "click a span" : 'active'

  initialize: () ->
    _.bindAll(this, "render")

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.index = @model.index
    $(@el).html(@template(attributes))
    this

  active: () ->
    @report_form.remove_tab_active_class()
    $(@el).addClass('active')
    $(@body.el).addClass('active')

  close: (ev) ->
    if @model.id?
      $(@body.el).find('#report_tabs_attributes_'+@model.index+'__destroy').val(1)
    @report_form.close_tab(@model, this)


class Analytics.Views.ReportTabs.FormBodyView extends Backbone.View
  template: JST["backbone/templates/report_tabs/form-body"]

  events:
    "click button.type-btn" : "change_chart_type"
    "click a#toggle-advanced-options" : "toggle_advanced_options"
    "click button.interval" : "change_interval"
    "change input#compare-checkbox" : "change_compare"

  initialize: () ->
    _.bindAll this, "render"

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.index = @model.index
    $(@el).html(@template(attributes))
    @render_metrics()
    @render_dimensions()
    this

  render_metrics: () ->
    $(@el).find("#report_tabs_"+@model.index+"_metrics").html(new Analytics.Views.Metrics.FormListView({
      model: {
        index: @model.index
        metric_ids: @model.get("metric_ids")
        project_id: @model.get("project_id")
      }
    }).render().el)

  render_dimensions: () ->
    $(@el).find("#report_tabs_"+@model.index+"_dimensions").html(new Analytics.Views.Dimensions.FormListView({
      model: {
        index: @model.index
        dimensions: @model.get("dimensions_attributes")
      }
    }).render().el)

  change_chart_type: (ev) ->
    $(@el).find('button.type-btn').removeClass('active')
    $(ev.currentTarget).addClass('active')
    $('#report_tabs_attributes_'+@model.index+'_chart_type').val($(ev.currentTarget).attr("value"))

  toggle_advanced_options: (ev) ->
    if $(ev.currentTarget).hasClass('active')
      $(ev.currentTarget).removeClass('active')
    else
      $(ev.currentTarget).addClass('active')
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