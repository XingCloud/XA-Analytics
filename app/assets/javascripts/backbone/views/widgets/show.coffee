Analytics.Views.Widgets ||= {}

class Analytics.Views.Widgets.ShowView extends Backbone.View
  template: JST["backbone/templates/widgets/show"]
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
    switch @model.get("widget_type")
      when "kpi","time"
        @chart = new Analytics.Collections.TimelineCharts([], {selector: @model, for_widget: true})
      when "table"
        @chart = new Analytics.Collections.DimensionCharts([], {selector: @model, for_widget: true})
    if @chart_view?
      @chart_view.remove()
      @chart_view = null

  render: () ->
    $(@el).html(@template(@model.attributes))
    $(@parent_el).append(@el)
    @render_chart()

  redraw: (options = {}) ->
    if options.parent_el? and (@parent_el != options.parent_el)
      @remove()
      @parent_el = options.parent_el
      $(@parent_el).append(@el)
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
          @chart_view = new Analytics.Views.Charts.DimensionsView(view_options)
      @chart_view.render()
    else
      @chart_view.redraw({render_to: render_to})
    @fetch_chart()

  fetch_chart: () ->
    el = $(@el).find(".widget-data")[0]
    chart_view = @chart_view
    $(el).block({message: "<strong>载入中...</strong>"})
    @chart.fetch_charts({
      success: (resp) ->
        chart_view.redraw()
        $(el).unblock()
      error: (xhr, options, err) ->
        $(el).unblock()
    })

  edit: () ->
    new Analytics.Views.Widgets.FormView({
      model: @model
    }).render()

  jump_to_report_tab: () ->
    report_tab = report_tabs_router.report_tabs.get(@model.get("report_tab_id"))
    report = reports_router.get(report_tab.get("report_id"))
    report.report_tab_index = report.report_tabs.indexOf(report_tab)
    window.location.href = '#/reports/' + report.id

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