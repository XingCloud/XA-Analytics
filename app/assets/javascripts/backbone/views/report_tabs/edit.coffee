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

class Analytics.Views.ReportTabs.EditListView extends Backbone.View

  report_tab_list: new Analytics.Collections.ReportTabs()
  index: 0

  initialize: () ->
    _.bindAll this, "addOne", "removeOne", "render"

  render: (report_tabs_options) ->
    for i in [0..report_tabs_options.length-1]
      @addTabView report_tabs_options[i], (i==0)
    true

  addOne: (report_tab_options) ->
    @addTabView(report_tab_options, false).headerView.click()

  removeOne: (tab_index) ->
    if @report_tab_list.length > 1
      report_tab = @report_tab_list.findTab tab_index

      if $(report_tab.headerView.el).hasClass('active')
        @report_tab_list.firstTab().headerView.click()

      report_tab.bodyView.destroy()
      report_tab.headerView.destroy()

      @report_tab_list.remove report_tab



  addTabView: (report_tab_options, active) ->
    report_tab_options['index'] = @index
    report_tab = new Analytics.Models.ReportTab(report_tab_options)

    header = new Analytics.Views.ReportTabs.EditHeaderView({
      model : report_tab,
      id : "report_tab_header" + @index,
      className : (if active then "active tab_header" else "tab_header")})

    $('#add_tab').before header.render().el
    body = new Analytics.Views.ReportTabs.EditBodyView({
      model : report_tab,
      id : "report_tab" + @index,
      className : (if active then "active tab-pane" else "tab-pane")})

    $("#tab_body_container").append body.render().el

    report_tab.metricsView =  new Analytics.Views.Metrics.EditListView()
    report_tab.metricsView.render(report_tab.metrics)

    @report_tab_list.add report_tab
    @index = @index + 1
    report_tab

  addMetric: (tab_index, metric_options) ->
    metric_options['tab_index'] = tab_index
    metric = new Analytics.Models.Metric(metric_options)
    report_tab = @report_tab_list.findTab(tab_index)
    report_tab.metrics.add(metric)
    report_tab.metricsView.addOne(metric)

  updateMetric: (tab_index, metric_options) ->
    report_tab = @report_tab_list.findTab(tab_index)
    report_tab.metrics.updateItem(metric_options)

