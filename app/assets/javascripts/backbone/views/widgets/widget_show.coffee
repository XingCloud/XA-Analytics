Analytics.Views.Widgets ||= {}


###
model: Instances.Collections.widgets[i]:Analytics.Models.Widget
###
class Analytics.Views.Widgets.ShowView extends Backbone.View
  template: JST["backbone/templates/widgets/widget_show"]
  tagName: "li"
  className: "widget"
  events:
    "click .widget-edit" : "edit"
    "click a.widget-report-tab" : "jump_to_report_tab"
    "click .next-page.active" : "next_table_page"
    "click .previous-page.active" : "previous_table_page"
    "click .dimensions-table th" : "sort_table"

  initialize: (options) ->
    _.bindAll this, "render", "remove", "redraw"
    @model.view = this
    @model.bind "change", @redraw
    @model.bind "destroy", @remove
    @parent_el = options.parent_el
    @initialize_chart()

  initialize_chart: () ->
    if @chart?
      last_request = @chart.last_request
      last_url = @chart.fetch_url()
    switch @model.get("widget_type")
      when "kpi","time"
        @chart = new Analytics.Collections.TimelineCharts([], {selector: @model, for_widget: true})
      when "table"
        @chart = new Analytics.Collections.DimensionCharts([], {selector: @model, for_widget: true})
    if last_request? and last_url == @chart.fetch_url()
      @chart.last_request = last_request
    if @chart_view?
      @chart_view.remove()
      @chart_view = null

  render: () ->
    $(@el).html(@template(@model.attributes))
    $(@parent_el).prepend(@el)
    @render_chart()

  redraw: (options = {}) ->
    if options.parent_el? and (@parent_el != options.parent_el)
      @remove()
      @parent_el = options.parent_el
      $(@parent_el).prepend(@el)
    @initialize_chart()
    $(@el).html(@template(@model.attributes))
    @render_chart()
    @delegateEvents(@events)


  render_chart: () ->
    @chart.initialize_charts([@model.get("metric_id")])
    render_to = $(@el).find("#widget_" + @model.id + "_chart")[0]
    if not @chart_view?
      view_options = {
        collection: @chart
        render_to: render_to
      }
      switch @model.get("widget_type")
        when "time"
          @chart_view = new Analytics.Views.Charts.TimelinesView(view_options)
        when "kpi"
          @chart_view = new Analytics.Views.Charts.KpisView(view_options)
        when "table"
          @chart_view = new Analytics.Views.Dimensions.TableView(view_options)
      @chart_view.render()
    else
      @chart_view.redraw({render_to: render_to})
    @fetch_chart()

  fetch_chart: (force = false) ->
    @chart.activate()
    el = $(@el).find(".widget-data")[0]
    chart_view = @chart_view
    chart_view.block()
    @chart.fetch_charts({
      success: (resp) ->
        chart_view.unblock()
      error: (xhr, options, err) ->
        chart_view.unblock()
    }, force)

  edit: () ->
    XA.action("click.dashboard.edit")
    new Analytics.Views.Widgets.FormView({
      model: @model
    }).render()

  jump_to_report_tab: () ->
    report_tab = Instances.Collections.report_tabs.get(@model.get("report_tab_id"))
    report = Instances.Collections.reports.get(report_tab.get("report_id"))
    report.report_tab_index = 0
    for report_tab_attributes in report.get("report_tabs_attributes")
      if parseInt(report_tab_attributes.id) == report_tab.id
        break
      report.report_tab_index = report.report_tab_index + 1
    Analytics.Utils.redirect("reports/" + report.id)

  next_table_page: (ev) ->
    page_num = Math.ceil(@chart.total / @chart.pagesize)
    if @chart.index + 1 < page_num
      @chart.index = @chart.index + 1
      @fetch_chart()

  previous_table_page: (ev) ->
    if @chart.index > 0
      @chart.index = @chart.index - 1
      @fetch_chart()

  sort_table: (ev) ->
    orderby = $(ev.currentTarget).attr("value")
    orderby = (if not orderby? then null else orderby)
    if orderby == @chart.orderby
      order = (if @chart.order.toUpperCase() == 'DESC' then 'ASC' else 'DESC')
    else
      order = 'DESC'
    @chart.order = order
    @chart.orderby = orderby
    @chart.index = 0
    @fetch_chart()