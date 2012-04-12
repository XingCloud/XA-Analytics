Analytics.Views.ReportTabs ||= {}

class Analytics.Views.ReportTabs.EditHeaderView extends Backbone.View
  template: JST["backbone/templates/report_tabs/edit_header"]
  tagName: "li"

  initialize: () ->
    _.bindAll(this, "render", "click")
    @model.bind "change", @render
    @model.headerView = this

  render: () ->
    $(@el).html(@template({model : @model}))
    this

  click: () ->
    $(@el).find('a[data-toggle="tab"]').click()

  destroy: () ->
    $(@el).remove()

class Analytics.Views.ReportTabs.EditBodyView extends Backbone.View
  template: JST["backbone/templates/report_tabs/edit_body"]
  tagName: "div"

  initialize: () ->
    _.bindAll this, "render"
    @model.bind "change", @render
    @model.bodyView = this

  render: () ->
    $(@el).html(@template({model : @model}))
    this

  destroy: () ->
    $(@el).remove()

