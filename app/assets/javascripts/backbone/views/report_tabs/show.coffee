Analytics.Views.ReportTabs ||= {}

#model: Analytics.Models.ReportTab
class Analytics.Views.ReportTabs.ShowView extends Backbone.View
  template: JST["backbone/templates/report_tabs/show"]
  events:
    "click .select-filter" : "select_filter"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @model.bind "change", @redraw
    @model.view = this
    @timelines = new Analytics.Collections.TimelineCharts([], {
      selector: @model
      filters: @model.dimensions_filters()
    })

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    $(@report_view.el).find('.tab-container').html($(@el))
    @render_panel()
    @render_timelines()
    @render_kpis()
    @render_dimensions()
    @fetch_data()

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  render_panel: () ->
    if not @model.panel_view?
      new Analytics.Views.ReportTabs.PanelView({
        model: @model
      })
      $(@report_view.el).find('.report-panel').html(@model.panel_view.render().el)
    else
      $(@report_view.el).find('.report-panel').html(@model.panel_view.redraw().el)
    $(@report_view.el).find('.report-panel').outerWidth($(@report_view.el).width())
    $(@report_view.el).find('.report-panel').affix()

  render_timelines: () ->
    segment_ids = Instances.Collections.segments.selected()
    @timelines.initialize_charts(@model.get("metric_ids"), segment_ids, @model.get("compare") != 0)
    render_to = $(@el).find("#report_tab_" + @model.id + "_timelines")[0]
    if not @timelines_view?
      @timelines_view = new Analytics.Views.Charts.TimelinesView({
        collection: @timelines
        render_to: render_to
      })
      @timelines_view.render()
    else
      @timelines_view.redraw({render_to: render_to})

  render_kpis: () ->
    render_to = $(@el).find("#report_tab_" + @model.id + "_kpis")[0]
    if not @kpis_view?
      @kpis_view = new Analytics.Views.Charts.KpisView({
        collection: @timelines
        render_to: render_to
        timelines_view: @timelines_view
      })
      @kpis_view.render()
    else
      @kpis_view.redraw({render_to: render_to})

  render_dimensions: () ->
    render_to = $(@el).find("#report_tab_" + @model.id + "_dimensions")[0]
    if not @dimensions_view?
      @dimensions_view = new Analytics.Views.Dimensions.ListView({
        model: @model
        render_to: render_to
        parent_view: this
      })
      @dimensions_view.render(false)
    else
      @dimensions_view.redraw({render_to: render_to, should_fetch: false})

  fetch_data: (blocking = true) ->
    if @model.get("metric_ids").length > 0
      @timelines.activate()
      if blocking?
        @timelines_view.block()
        if @model.dimension?
          @dimensions_view.block()
      timelines_view = @timelines_view
      kpis_view = @kpis_view
      dimensions_view = @dimensions_view
      @timelines.fetch_charts({
        success: (resp) ->
          timelines_view.unblock()
        error: (xhr, options, err) ->
          timelines_view.unblock()
      }, @model.force_fetch)
      if @model.dimension?
        @dimensions_view.dimensions.activate()
        @dimensions_view.dimensions.fetch_charts({
          success: (resp) ->
            dimensions_view.dimensions_chart_view.redraw()
            dimensions_view.unblock()
          error: (xhr, options, err) ->
            dimensions_view.unblock()
        }, @model.force_fetch)
      @model.force_fetch = false


  select_filter: (ev) ->
    value = $(ev.currentTarget).attr("value")
    type = $(ev.currentTarget).attr("type")
    if type.toUpperCase() == 'ALL'
      @model.dimension = @model.dimensions[0]
      @model.dimensions_filters().splice(0, @model.dimensions_filters().length)
    else
      @model.dimension = _.find(@model.dimensions, (item) ->
        item.value == value and item.dimension_type == type
      )
      dimension_filter = _.find(@model.dimensions_filters(), (item) ->
        item.dimension.value == value and item.dimension.dimension_type == type
      )
      dimension_filter_index = @model.dimensions_filters().indexOf(dimension_filter)
      @model.dimensions_filters().splice(dimension_filter_index + 1, @model.dimensions_filters().length - dimension_filter_index - 1)
    @redraw()
