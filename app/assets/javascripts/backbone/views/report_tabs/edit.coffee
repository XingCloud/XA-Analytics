Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.EditHeaderView extends Backbone.View
  template: JST["backbone/templates/report_tabs/edit_header"]

  initialize: () ->
    _.bindAll(this, "render", "click")
    @model.bind "change", @render
    @model.headerView = this

  render: () ->
    $(@el).html(@template({model : @model}))

  click: () ->
    $(@el).find('a[data-toggle="tab"]').click()

  destroy: () ->
    $(@el).remove()

class Analytics.Views.ReportTabs.EditBodyView extends Backbone.View
  template: JST["backbone/templates/report_tabs/edit_body"]
  events:
    "click .type-btn" : "change_type"

  initialize: () ->
    _.bindAll this, "render"
    @model.bind "change", @render
    @model.bodyView = this

  render: () ->
    $(@el).html(@template({model : @model}))

  destroy: () ->
    $(@el).remove()

  change_type: (ev) ->
    $(@el).find(' .type-btn').removeClass('active')
    $(ev.currentTarget).addClass('active')
    $('#report_report_tabs_attributes_'+@model.get("index")+'_chart_type').val($(ev.currentTarget).attr("value"))

