Analytics.Views.Reports ||= {}

class Analytics.Views.Reports.ShowView extends Backbone.View
  template: JST['backbone/templates/reports/show']

  events:
    "click a.segment-btn" : "toggle_segments"
    "click a.refresh-btn" : "refresh"
    "click li.report-tab" : "change_tab"

  initialize: (options) ->
    _.bindAll(this, "render", "redraw")
    @model.view = this

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    $('#main-container').html($(@el))
    @render_report_tab()

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  render_segments: () ->
    $(@el).find('.segments').html(new Analytics.Views.Segments.ListView({
      segments: segments_router.segments,
      templates: segments_router.templates,
      parent: this
    }).render().el)

  render_report_tab: () ->
    if @model.report_tabs.length
      report_tab = @model.report_tabs[@model.report_tab_index]
      project.active_tab = report_tab
      if report_tab.view?
        report_tab.view.redraw()
      else
        new Analytics.Views.ReportTabs.ShowView({
          model: report_tab,
          id : 'report_tab_'+report_tab.id
        })
        report_tab.view.report_view = this
        report_tab.view.render()

  reset_segments_select: () ->
    segments_router.segments.reset_selected(@segments_selected)
    segments_router.templates.reset_selected(@template_segments_selected)

  hide_segments: () ->
    $(@el).find('.segment-btn').removeClass('active')
    $(@el).find('.segments').empty()

  toggle_segments: () ->
    if $(@el).find('.segment-btn').hasClass('active')
      @hide_segments()
      @reset_segments_select()
    else
      @segments_selected = segments_router.segments.selected()
      @template_segments_selected = segments_router.templates.selected()
      @render_segments()
      $(@el).find('.segment-btn').addClass('active')

  change_tab: (ev) ->
    $(@el).find('.report-tabs ul li').removeClass('active')
    $(ev.currentTarget).addClass('active')
    @model.report_tab_index = parseInt($(ev.currentTarget).attr("value"))
    @render_report_tab()

  refresh: (ev) ->
    report_tab_index = $(@el).find('.report-tabs ul li.active').attr('value')
    report_tab = @model.report_tabs[report_tab_index]
    report_tab.trigger("change")
