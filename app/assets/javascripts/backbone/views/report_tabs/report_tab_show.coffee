Analytics.Views.ReportTabs ||= {}

#model: Analytics.Models.ReportTab
class Analytics.Views.ReportTabs.ShowView extends Backbone.View
  template: JST["backbone/templates/report_tabs/report_tab_show"]

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @model.bind "change", @redraw #report change: triggered by panel or edit report, see report.parse
    @model.view = this

    @timelines = new Analytics.Collections.TimelineCharts([], {
      selector: @model
      filters: @model.dimensions_filters()
    })
    @timelines.initialize_charts(@model.get("metric_ids"), Instances.Collections.segments.selected(), @model.get("compare") != 0) #todo wcl: can not be placed in @timeline.initialize, why?

    # for thread safety reasons: reconstruct dimensions collection each time we change dimensions
    @dimensions = new Analytics.Collections.DimensionCharts([], {  # the original object will be destroyed by js gc
      selector: @model # report_tab
      filters: @model.dimensions_filters()
    })
    @dimensions.initialize_charts(@model.get("metric_ids"), Instances.Collections.segments.selected())
    @dimensions.orderby = @model.get("metric_ids")[0] if @model.get("metric_ids")[0]?

  render: () ->
    $(@el).html(@template(@model.show_attributes()))   #report_tab.show_attributes() will check if we need to set report_tab.dimenssion to null, like we click one dimension value
    $(@report_view.el).find('.tab-container').html($(@el))
    @render_timelines()
    @timelines
    @render_kpis()
    @render_dimensions()
    @render_panel() # must be after render_dimensions
    @fetch_data()

  redraw: () ->
    # redraw may by invoked after we change the segments or add dimension filter on the panel
    @timelines.reinitialize_chart()
    @dimensions.reinitialize_chart()

    @remove()
    @render()
    @delegateEvents(@events)

  render_panel: () ->
    if not @model.panel_view?
      new Analytics.Views.ReportTabs.PanelView({
        model: @model  # report_tab
        parent_view: this
      })
      $('div.report-panel').html(@model.panel_view.render().el)
    else
      $('div.report-panel').html(@model.panel_view.redraw().el)
#    $('div.report-panel').outerWidth($(@report_view.el).width()) //todo
    $('div.report-panel').affix({
      offset: 45
    })
    $('.report-panel-shadow').height($('.report-panel').height()+8)

  render_timelines: () ->
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
      @dimensions_view = new Analytics.Views.Charts.DimensionsView({
        collection: @dimensions
        report_tab: @model  # report_tab
        render_to: render_to
        report_tab_view: this
      })
      @dimensions_view.render(false)
    else
      @dimensions_view.redraw({render_to: render_to, should_fetch: false})

  fetch_data: () ->
    if @model.get("metric_ids").length > 0
      @timelines.activate()
      @timelines_view.block()
      timelines_view = @timelines_view
      @timelines.fetch_charts({
        success: (resp) ->
          timelines_view.unblock()
        error: (xhr, options, err) ->
          timelines_view.unblock()
      }, @model.force_fetch)

      if @model.dimension?  # if we have dimension to deal with, modified by panel
        dimensions_view = @dimensions_view
        @dimensions.reinitialize_chart() # reinit in case we add/delete/... dimensons between render_dimension and fetch_data.
        @dimensions_view.block()
        @dimensions_view.dimensions.fetch_charts({
          success: (resp) ->
            dimensions_view.unblock()
          error: (xhr, options, err) ->
            dimensions_view.unblock()
        }, @model.force_fetch)
      @model.force_fetch = false
