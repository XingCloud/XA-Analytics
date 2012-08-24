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
      parent: this
    }).render().el)

  render_report_tab: () ->
    if @model.get("report_tabs_attributes").length
      report_tab_attributes = @model.get("report_tabs_attributes")[@model.report_tab_index]
      report_tab = Instances.Collections.report_tabs.get(report_tab_attributes.id)
      Instances.Models.project.active_tab = report_tab
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
    Instances.Collections.segments.reset_selected(@segments_selected)

  hide_segments: () ->
    $(@el).find('.segment-btn').removeClass('active')
    $(@el).find('.segments').empty()

  toggle_segments: () ->
    if $(@el).find('.segment-btn').hasClass('active')
      @hide_segments()
      @reset_segments_select()
    else
      @segments_selected = Instances.Collections.segments.selected()
      @render_segments()
      $(@el).find('.segment-btn').addClass('active')

  change_tab: (ev) ->
    $(@el).find('.report-tabs ul li').removeClass('active')
    $(ev.currentTarget).addClass('active')
    @model.report_tab_index = parseInt($(ev.currentTarget).attr("value"))
    @render_report_tab()

  refresh: (ev) ->
    report_tab_index = $(@el).find('.report-tabs ul li.active').attr('value')
    report_tab_attributes = @model.get("report_tabs_attributes")[report_tab_index]
    report_tab = Instances.Collections.report_tabs.get(report_tab_attributes.id)
    report_tab.force_fetch = true
    report_tab.trigger("change")
